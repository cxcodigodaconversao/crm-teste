'use client';

import React, { useState, useEffect } from 'react';
import {
  DragDropContext,
  Droppable,
  Draggable,
  DropResult,
} from '@hello-pangea/dnd';
import { Plus, Filter, Search, MoreVertical } from 'lucide-react';
import { LeadCard } from './LeadCard';
import { LeadSidebar } from './LeadSidebar';
import { ScheduleModal } from './ScheduleModal';
import { CallOutcomeModal } from './CallOutcomeModal';
import { useKanban } from '../hooks/useKanban';
import { Lead, Stage } from '@/types/crm';

interface KanbanProps {
  pipelineId: string;
  userId: string;
  userRole: 'admin' | 'closer' | 'sdr' | 'viewer';
}

export function Kanban({ pipelineId, userId, userRole }: KanbanProps) {
  const {
    stages,
    leads,
    loading,
    error,
    moveLead,
    refreshData,
  } = useKanban(pipelineId);

  const [selectedLead, setSelectedLead] = useState<Lead | null>(null);
  const [scheduleModalOpen, setScheduleModalOpen] = useState(false);
  const [callOutcomeModalOpen, setCallOutcomeModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterOwner, setFilterOwner] = useState<string>('all');
  const [filterDISC, setFilterDISC] = useState<string>('all');

  // WebSocket para atualizações em tempo real
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const socket = new WebSocket(
        process.env.NEXT_PUBLIC_WS_URL || 'ws://localhost:3001'
      );

      socket.onmessage = (event) => {
        const data = JSON.parse(event.data);
        if (data.type === 'lead_updated' && data.pipelineId === pipelineId) {
          refreshData();
        }
      };

      return () => socket.close();
    }
  }, [pipelineId, refreshData]);

  const handleDragEnd = async (result: DropResult) => {
    const { source, destination, draggableId } = result;

    // Dropped outside
    if (!destination) return;

    // Same position
    if (
      source.droppableId === destination.droppableId &&
      source.index === destination.index
    ) {
      return;
    }

    const leadId = draggableId;
    const fromStageId = source.droppableId;
    const toStageId = destination.droppableId;
    const lead = leads.find((l) => l.id === leadId);
    const toStage = stages.find((s) => s.id === toStageId);

    if (!lead || !toStage) return;

    try {
      await moveLead(leadId, fromStageId, toStageId);

      // Regras de automação baseadas no estágio de destino
      if (toStage.name.toLowerCase().includes('diagnóstico agendado')) {
        // Abrir modal de agendamento
        setSelectedLead(lead);
        setScheduleModalOpen(true);
      } else if (toStage.name.toLowerCase().includes('call realizada')) {
        // Abrir modal de resultado da call
        setSelectedLead(lead);
        setCallOutcomeModalOpen(true);
      } else if (toStage.is_closed) {
        // Exigir valor do deal e motivo
        setSelectedLead(lead);
        // Abrir modal de fechamento (implementar)
      }
    } catch (err) {
      console.error('Erro ao mover lead:', err);
      // Reverter visualmente ou mostrar toast de erro
    }
  };

  const getLeadsByStage = (stageId: string) => {
    return leads
      .filter((lead) => {
        // Filtro por estágio
        if (lead.stage_id !== stageId) return false;

        // Filtro por busca
        if (searchTerm) {
          const search = searchTerm.toLowerCase();
          return (
            lead.name.toLowerCase().includes(search) ||
            lead.company?.toLowerCase().includes(search) ||
            lead.email?.toLowerCase().includes(search) ||
            lead.phone?.includes(search)
          );
        }

        // Filtro por owner
        if (filterOwner !== 'all' && lead.owner_id !== filterOwner) {
          return false;
        }

        // Filtro por DISC
        if (filterDISC !== 'all' && lead.disc_profile !== filterDISC) {
          return false;
        }

        return true;
      })
      .sort((a, b) => {
        // Ordenar por última atividade (mais recente primeiro)
        return (
          new Date(b.last_activity_at).getTime() -
          new Date(a.last_activity_at).getTime()
        );
      });
  };

  const getStageColor = (stageName: string, isWon?: boolean) => {
    if (isWon === true) return '#10b981'; // verde
    if (isWon === false) return '#ef4444'; // vermelho
    
    // Mapeamento de cores por nome de estágio
    const colorMap: Record<string, string> = {
      'novo contato': '#94a3b8',
      'diagnóstico agendado': '#60a5fa',
      'call realizada': '#a78bfa',
      'proposta enviada': '#f59e0b',
      'follow-up': '#fbbf24',
    };

    return colorMap[stageName.toLowerCase()] || '#d2bc8f';
  };

  const canEdit = ['admin', 'closer', 'sdr'].includes(userRole);

  if (loading) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-[#d2bc8f]"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="p-4 bg-red-50 border border-red-200 rounded-lg">
        <p className="text-red-800">Erro ao carregar pipeline: {error}</p>
      </div>
    );
  }

  return (
    <div className="h-full flex flex-col">
      {/* Header com filtros */}
      <div className="bg-[#1a2332] p-4 border-b border-[#333] flex items-center justify-between gap-4">
        <div className="flex items-center gap-4 flex-1">
          {/* Busca */}
          <div className="relative flex-1 max-w-md">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
            <input
              type="text"
              placeholder="Buscar leads..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 bg-[#2a3441] border border-[#444] rounded-lg text-white placeholder-gray-400 focus:outline-none focus:border-[#d2bc8f]"
            />
          </div>

          {/* Filtros */}
          <button className="flex items-center gap-2 px-4 py-2 bg-[#2a3441] border border-[#444] rounded-lg text-white hover:bg-[#333] transition-colors">
            <Filter className="w-4 h-4" />
            <span>Filtros</span>
          </button>
        </div>

        {/* Novo Lead */}
        {canEdit && (
          <button className="flex items-center gap-2 px-4 py-2 bg-[#d2bc8f] text-[#0c121c] rounded-lg font-medium hover:bg-[#e6d0a3] transition-colors">
            <Plus className="w-4 h-4" />
            <span>Novo Lead</span>
          </button>
        )}
      </div>

      {/* Kanban Board */}
      <div className="flex-1 overflow-x-auto overflow-y-hidden p-4">
        <DragDropContext onDragEnd={handleDragEnd}>
          <div className="flex gap-4 h-full min-w-max">
            {stages.map((stage) => {
              const stageLeads = getLeadsByStage(stage.id);
              const totalValue = stageLeads.reduce(
                (sum, lead) => sum + (lead.deal_value || 0),
                0
              );

              return (
                <div
                  key={stage.id}
                  className="w-80 flex flex-col bg-[#1a2332] rounded-lg"
                  style={{
                    borderTop: `3px solid ${getStageColor(stage.name, stage.is_won)}`,
                  }}
                >
                  {/* Stage Header */}
                  <div className="p-4 border-b border-[#333]">
                    <div className="flex items-center justify-between mb-2">
                      <h3 className="font-semibold text-white">{stage.name}</h3>
                      <button className="text-gray-400 hover:text-white">
                        <MoreVertical className="w-4 h-4" />
                      </button>
                    </div>
                    <div className="flex items-center justify-between text-sm">
                      <span className="text-gray-400">
                        {stageLeads.length} lead{stageLeads.length !== 1 && 's'}
                      </span>
                      {totalValue > 0 && (
                        <span className="text-[#d2bc8f] font-medium">
                          R$ {totalValue.toLocaleString('pt-BR')}
                        </span>
                      )}
                    </div>
                  </div>

                  {/* Droppable Area */}
                  <Droppable droppableId={stage.id}>
                    {(provided, snapshot) => (
                      <div
                        ref={provided.innerRef}
                        {...provided.droppableProps}
                        className={`flex-1 overflow-y-auto p-2 space-y-2 ${
                          snapshot.isDraggingOver ? 'bg-[#2a3441]' : ''
                        }`}
                        style={{
                          minHeight: '200px',
                          maxHeight: 'calc(100vh - 250px)',
                        }}
                      >
                        {stageLeads.map((lead, index) => (
                          <Draggable
                            key={lead.id}
                            draggableId={lead.id}
                            index={index}
                            isDragDisabled={!canEdit}
                          >
                            {(provided, snapshot) => (
                              <div
                                ref={provided.innerRef}
                                {...provided.draggableProps}
                                {...provided.dragHandleProps}
                              >
                                <LeadCard
                                  lead={lead}
                                  isDragging={snapshot.isDragging}
                                  onClick={() => setSelectedLead(lead)}
                                  onSchedule={() => {
                                    setSelectedLead(lead);
                                    setScheduleModalOpen(true);
                                  }}
                                  onMessage={() => {
                                    // Abrir inbox/thread
                                  }}
                                />
                              </div>
                            )}
                          </Draggable>
                        ))}
                        {provided.placeholder}

                        {stageLeads.length === 0 && (
                          <div className="text-center text-gray-500 py-8">
                            Nenhum lead neste estágio
                          </div>
                        )}
                      </div>
                    )}
                  </Droppable>
                </div>
              );
            })}
          </div>
        </DragDropContext>
      </div>

      {/* Modals */}
      {selectedLead && (
        <>
          <LeadSidebar
            lead={selectedLead}
            isOpen={!!selectedLead}
            onClose={() => setSelectedLead(null)}
            onSchedule={() => setScheduleModalOpen(true)}
          />

          <ScheduleModal
            isOpen={scheduleModalOpen}
            onClose={() => setScheduleModalOpen(false)}
            lead={selectedLead}
          />

          <CallOutcomeModal
            isOpen={callOutcomeModalOpen}
            onClose={() => setCallOutcomeModalOpen(false)}
            lead={selectedLead}
          />
        </>
      )}
    </div>
  );
}
