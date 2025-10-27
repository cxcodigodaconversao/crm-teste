'use client';

import React from 'react';
import {
  Calendar,
  MessageCircle,
  Instagram,
  Phone,
  Mail,
  Clock,
  AlertCircle,
  CheckCircle2,
} from 'lucide-react';
import { DISCBadge } from './DISCBadge';
import { Lead } from '@/types/crm';
import { formatDistanceToNow } from 'date-fns';
import { ptBR } from 'date-fns/locale';

interface LeadCardProps {
  lead: Lead;
  isDragging?: boolean;
  onClick?: () => void;
  onSchedule?: () => void;
  onMessage?: () => void;
}

export function LeadCard({
  lead,
  isDragging = false,
  onClick,
  onSchedule,
  onMessage,
}: LeadCardProps) {
  // Calcular dias desde última atividade
  const daysSinceLastActivity = lead.last_activity_at
    ? Math.floor(
        (Date.now() - new Date(lead.last_activity_at).getTime()) /
          (1000 * 60 * 60 * 24)
      )
    : null;

  // Verificar se está em risco (>7 dias sem atividade)
  const isAtRisk = daysSinceLastActivity !== null && daysSinceLastActivity > 7;

  // Verificar se tem mensagens não lidas
  const hasUnreadMessages = (lead.unread_messages_count || 0) > 0;

  // Verificar se tem tarefas pendentes
  const hasOpenTasks = (lead.open_tasks_count || 0) > 0;

  // Verificar se tem eventos agendados
  const hasUpcomingEvents = (lead.upcoming_events_count || 0) > 0;

  return (
    <div
      onClick={onClick}
      className={`
        bg-[#2a3441] rounded-lg p-3 cursor-pointer
        border border-[#444] hover:border-[#d2bc8f] 
        transition-all duration-200
        ${isDragging ? 'opacity-50 rotate-2 shadow-2xl' : 'hover:shadow-lg'}
        ${isAtRisk ? 'border-l-4 border-l-red-500' : ''}
      `}
    >
      {/* Header: Nome + DISC Badge */}
      <div className="flex items-start justify-between gap-2 mb-2">
        <div className="flex-1 min-w-0">
          <h4 className="font-semibold text-white truncate">{lead.name}</h4>
          {lead.company && (
            <p className="text-sm text-gray-400 truncate">{lead.company}</p>
          )}
        </div>

        {lead.disc_profile && <DISCBadge profile={lead.disc_profile} />}
      </div>

      {/* Valor do deal */}
      {lead.deal_value && lead.deal_value > 0 && (
        <div className="mb-2">
          <span className="text-lg font-bold text-[#d2bc8f]">
            R$ {lead.deal_value.toLocaleString('pt-BR')}
          </span>
          {lead.probability && (
            <span className="ml-2 text-xs text-gray-400">
              {lead.probability}% prob.
            </span>
          )}
        </div>
      )}

      {/* Contatos */}
      <div className="space-y-1 mb-3">
        {lead.phone && (
          <div className="flex items-center gap-2 text-xs text-gray-300">
            <Phone className="w-3 h-3 text-gray-400" />
            <span className="truncate">{lead.phone}</span>
          </div>
        )}
        {lead.email && (
          <div className="flex items-center gap-2 text-xs text-gray-300">
            <Mail className="w-3 h-3 text-gray-400" />
            <span className="truncate">{lead.email}</span>
          </div>
        )}
        {lead.instagram_handle && (
          <div className="flex items-center gap-2 text-xs text-gray-300">
            <Instagram className="w-3 h-3 text-gray-400" />
            <span className="truncate">{lead.instagram_handle}</span>
          </div>
        )}
      </div>

      {/* Tags */}
      {lead.tags && lead.tags.length > 0 && (
        <div className="flex flex-wrap gap-1 mb-3">
          {lead.tags.slice(0, 3).map((tag, index) => (
            <span
              key={index}
              className="px-2 py-0.5 text-xs bg-[#1a2332] text-gray-300 rounded-full border border-[#444]"
            >
              {tag}
            </span>
          ))}
          {lead.tags.length > 3 && (
            <span className="px-2 py-0.5 text-xs text-gray-400">
              +{lead.tags.length - 3}
            </span>
          )}
        </div>
      )}

      {/* Indicators */}
      <div className="flex flex-wrap gap-2 mb-3">
        {hasUnreadMessages && (
          <div className="flex items-center gap-1 text-xs text-blue-400">
            <MessageCircle className="w-3 h-3" />
            <span>{lead.unread_messages_count}</span>
          </div>
        )}

        {hasOpenTasks && (
          <div className="flex items-center gap-1 text-xs text-orange-400">
            <CheckCircle2 className="w-3 h-3" />
            <span>{lead.open_tasks_count}</span>
          </div>
        )}

        {hasUpcomingEvents && (
          <div className="flex items-center gap-1 text-xs text-green-400">
            <Calendar className="w-3 h-3" />
            <span>{lead.upcoming_events_count}</span>
          </div>
        )}

        {isAtRisk && (
          <div className="flex items-center gap-1 text-xs text-red-400">
            <AlertCircle className="w-3 h-3" />
            <span>{daysSinceLastActivity}d</span>
          </div>
        )}
      </div>

      {/* Footer: Última atividade */}
      {lead.last_activity_at && (
        <div className="flex items-center gap-1 text-xs text-gray-500 border-t border-[#333] pt-2">
          <Clock className="w-3 h-3" />
          <span>
            {formatDistanceToNow(new Date(lead.last_activity_at), {
              addSuffix: true,
              locale: ptBR,
            })}
          </span>
        </div>
      )}

      {/* Quick Actions (aparecem no hover) */}
      <div className="mt-2 flex gap-1 opacity-0 hover:opacity-100 transition-opacity">
        <button
          onClick={(e) => {
            e.stopPropagation();
            onSchedule?.();
          }}
          className="flex-1 px-2 py-1 text-xs bg-[#1a2332] text-white rounded hover:bg-[#0c121c] transition-colors"
          title="Agendar"
        >
          <Calendar className="w-3 h-3 mx-auto" />
        </button>

        <button
          onClick={(e) => {
            e.stopPropagation();
            onMessage?.();
          }}
          className="flex-1 px-2 py-1 text-xs bg-[#1a2332] text-white rounded hover:bg-[#0c121c] transition-colors"
          title="Mensagem"
        >
          <MessageCircle className="w-3 h-3 mx-auto" />
        </button>
      </div>

      {/* AI Score (se disponível) */}
      {lead.ai_score !== null && lead.ai_score !== undefined && (
        <div className="mt-2 flex items-center justify-between text-xs">
          <span className="text-gray-400">AI Score</span>
          <div className="flex items-center gap-1">
            <div className="w-16 h-1 bg-[#1a2332] rounded-full overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-red-500 via-yellow-500 to-green-500"
                style={{ width: `${lead.ai_score}%` }}
              />
            </div>
            <span className="text-white font-medium">{lead.ai_score}</span>
          </div>
        </div>
      )}
    </div>
  );
}
