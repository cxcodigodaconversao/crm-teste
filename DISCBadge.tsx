'use client';

import React, { useState } from 'react';

type DISCProfile = 'D' | 'I' | 'S' | 'C';

interface DISCBadgeProps {
  profile: DISCProfile;
  size?: 'sm' | 'md' | 'lg';
  showTooltip?: boolean;
}

const DISCConfig = {
  D: {
    label: 'Dominante',
    color: '#ef4444', // vermelho
    description: 'Direto, objetivo, focado em resultados. Não gosta de enrolação.',
    approach: 'Seja direto e objetivo. Foque em resultados e eficiência.',
    icon: '🔴',
  },
  I: {
    label: 'Influente',
    color: '#f59e0b', // amarelo/laranja
    description: 'Comunicativo, entusiasta, sociável. Gosta de interação.',
    approach: 'Seja animado e mostre cases de sucesso. Use storytelling.',
    icon: '🟡',
  },
  S: {
    label: 'Estável',
    color: '#10b981', // verde
    description: 'Calmo, paciente, leal. Valoriza relacionamento e segurança.',
    approach: 'Dê tempo para decidir. Foque em relacionamento e suporte.',
    icon: '🟢',
  },
  C: {
    label: 'Cauteloso',
    color: '#3b82f6', // azul
    description: 'Analítico, detalhista, preciso. Quer dados e evidências.',
    approach: 'Forneça dados, detalhes técnicos e evidências concretas.',
    icon: '🔵',
  },
};

export function DISCBadge({
  profile,
  size = 'md',
  showTooltip = true,
}: DISCBadgeProps) {
  const [showInfo, setShowInfo] = useState(false);
  const config = DISCConfig[profile];

  const sizeClasses = {
    sm: 'w-6 h-6 text-xs',
    md: 'w-8 h-8 text-sm',
    lg: 'w-10 h-10 text-base',
  };

  return (
    <div className="relative">
      <div
        className={`
          ${sizeClasses[size]}
          rounded-full flex items-center justify-center
          font-bold text-white cursor-help
          shadow-lg border-2 border-white/20
        `}
        style={{ backgroundColor: config.color }}
        onMouseEnter={() => showTooltip && setShowInfo(true)}
        onMouseLeave={() => showTooltip && setShowInfo(false)}
        title={config.label}
      >
        {profile}
      </div>

      {/* Tooltip */}
      {showTooltip && showInfo && (
        <div className="absolute z-50 w-72 p-4 bg-[#1a2332] border border-[#444] rounded-lg shadow-2xl top-full mt-2 right-0">
          {/* Arrow */}
          <div
            className="absolute -top-2 right-3 w-4 h-4 bg-[#1a2332] border-t border-l border-[#444] transform rotate-45"
          />

          {/* Content */}
          <div className="relative">
            {/* Header */}
            <div className="flex items-center gap-2 mb-3">
              <div
                className="w-10 h-10 rounded-full flex items-center justify-center text-2xl"
                style={{ backgroundColor: config.color + '20' }}
              >
                {config.icon}
              </div>
              <div>
                <h4 className="font-bold text-white text-lg">
                  Perfil {profile}
                </h4>
                <p className="text-sm text-gray-400">{config.label}</p>
              </div>
            </div>

            {/* Description */}
            <div className="space-y-3">
              <div>
                <h5 className="text-xs font-semibold text-[#d2bc8f] uppercase mb-1">
                  Características
                </h5>
                <p className="text-sm text-gray-300">{config.description}</p>
              </div>

              <div>
                <h5 className="text-xs font-semibold text-[#d2bc8f] uppercase mb-1">
                  Como abordar
                </h5>
                <p className="text-sm text-gray-300">{config.approach}</p>
              </div>
            </div>

            {/* Color indicator */}
            <div className="mt-3 pt-3 border-t border-[#333]">
              <div className="flex items-center gap-2">
                <div
                  className="w-4 h-4 rounded-full"
                  style={{ backgroundColor: config.color }}
                />
                <span className="text-xs text-gray-400">
                  Cor no Kanban: {profile}
                </span>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

// Componente auxiliar para mostrar legenda DISC
export function DISCLegend() {
  return (
    <div className="flex flex-wrap gap-4 p-4 bg-[#1a2332] rounded-lg border border-[#444]">
      <h3 className="w-full text-sm font-semibold text-[#d2bc8f] uppercase mb-2">
        Legenda DISC
      </h3>
      {(Object.keys(DISCConfig) as DISCProfile[]).map((profile) => {
        const config = DISCConfig[profile];
        return (
          <div key={profile} className="flex items-center gap-2">
            <div
              className="w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold text-white"
              style={{ backgroundColor: config.color }}
            >
              {profile}
            </div>
            <div>
              <p className="text-sm font-medium text-white">{config.label}</p>
              <p className="text-xs text-gray-400">{config.icon} {config.description.split('.')[0]}</p>
            </div>
          </div>
        );
      })}
    </div>
  );
}

// Hook para sugerir DISC baseado em texto
export function useDISCSuggestion(text: string): DISCProfile | null {
  // Palavras-chave para cada perfil
  const keywords = {
    D: [
      'rápido',
      'urgente',
      'resultado',
      'eficiente',
      'direto',
      'objetivo',
      'prazo',
      'agora',
      'imediato',
    ],
    I: [
      'animado',
      'legal',
      'adorei',
      'incrível',
      'fantástico',
      'equipe',
      'pessoas',
      'social',
      'networking',
    ],
    S: [
      'calma',
      'seguro',
      'confiança',
      'relacionamento',
      'apoio',
      'suporte',
      'tempo',
      'parceria',
      'longo prazo',
    ],
    C: [
      'dados',
      'análise',
      'detalhe',
      'precisão',
      'técnico',
      'evidência',
      'documento',
      'relatório',
      'especificação',
    ],
  };

  if (!text) return null;

  const lowerText = text.toLowerCase();
  const scores = {
    D: 0,
    I: 0,
    S: 0,
    C: 0,
  };

  // Contar ocorrências de palavras-chave
  (Object.keys(keywords) as DISCProfile[]).forEach((profile) => {
    keywords[profile].forEach((keyword) => {
      if (lowerText.includes(keyword)) {
        scores[profile]++;
      }
    });
  });

  // Retornar perfil com maior score (se houver empate, retorna null)
  const maxScore = Math.max(...Object.values(scores));
  if (maxScore === 0) return null;

  const profiles = (Object.keys(scores) as DISCProfile[]).filter(
    (p) => scores[p] === maxScore
  );

  return profiles.length === 1 ? profiles[0] : null;
}
