// types/crm.ts
// Tipos centralizados para todo o sistema CRM

export type UserRole = 'admin' | 'closer' | 'sdr' | 'viewer';

export type DISCProfile = 'D' | 'I' | 'S' | 'C';

export type LeadSource =
  | 'website'
  | 'instagram'
  | 'whatsapp'
  | 'referral'
  | 'cold_call'
  | 'event'
  | 'other';

export type EventStatus =
  | 'scheduled'
  | 'rescheduled'
  | 'cancelled'
  | 'completed'
  | 'no_show';

export type MessageChannel = 'whatsapp' | 'instagram' | 'internal' | 'email';

export type MessageDirection = 'in' | 'out';

export type ActivityType =
  | 'stage_move'
  | 'note'
  | 'task'
  | 'status_change'
  | 'message'
  | 'call_outcome'
  | 'lead_created'
  | 'lead_assigned';

export type TaskStatus = 'open' | 'done' | 'cancelled';

export type IntegrationVendor =
  | 'google'
  | 'waba'
  | 'instagram'
  | 'zoom'
  | 'email';

export type TemplateType = 'whatsapp' | 'instagram_dm' | 'email' | 'script';

export type CallOutcome =
  | 'completed'
  | 'no_show'
  | 'rescheduled'
  | 'cancelled'
  | 'interested'
  | 'not_interested';

// ============================================
// USER
// ============================================

export interface User {
  id: string;
  email: string;
  name: string;
  password_hash?: string;
  role: UserRole;
  timezone: string;
  avatar_url?: string;
  phone?: string;
  google_calendar_connected: boolean;
  google_refresh_token?: string;
  google_access_token?: string;
  google_token_expires_at?: Date;
  active: boolean;
  created_at: Date;
  updated_at: Date;
  last_login_at?: Date;
}

// ============================================
// PIPELINE & STAGES
// ============================================

export interface Pipeline {
  id: string;
  name: string;
  description?: string;
  color: string;
  is_default: boolean;
  created_by?: string;
  created_at: Date;
  updated_at: Date;
  deleted_at?: Date;
}

export interface Stage {
  id: string;
  pipeline_id: string;
  name: string;
  order: number;
  color: string;
  is_closed: boolean;
  is_won: boolean;
  created_at: Date;
  updated_at: Date;
}

// ============================================
// LEAD
// ============================================

export interface Lead {
  id: string;
  name: string;
  email?: string;
  phone?: string;
  instagram_handle?: string;
  company?: string;

  // Pipeline & Stage
  pipeline_id: string;
  stage_id: string;

  // Ownership
  owner_id?: string;
  created_by?: string;

  // Lead Info
  source: LeadSource;
  disc_profile?: DISCProfile;
  deal_value?: number;
  probability?: number;
  expected_close_date?: Date;

  // AI/ML
  ai_score?: number;
  ai_disc_suggestion?: DISCProfile;

  // Metadata
  notes?: string;
  tags?: string[];
  custom_fields?: Record<string, any>;

  // Tracking
  last_contact_at?: Date;
  last_activity_at: Date;
  created_at: Date;
  updated_at: Date;
  deleted_at?: Date;

  // Agregados (da view leads_with_stats)
  owner_name?: string;
  owner_email?: string;
  stage_name?: string;
  pipeline_name?: string;
  messages_count?: number;
  unread_messages_count?: number;
  open_tasks_count?: number;
  upcoming_events_count?: number;
  last_message_at?: Date;
  days_since_last_activity?: number;
}

// ============================================
// EVENT (Google Calendar)
// ============================================

export interface Event {
  id: string;
  lead_id: string;
  google_event_id?: string;

  // Event details
  title: string;
  description?: string;
  start_time: Date;
  end_time: Date;
  timezone: string;

  // Location/Link
  location?: string;
  meeting_link?: string;

  // Status
  status: EventStatus;
  outcome?: CallOutcome;
  outcome_notes?: string;

  // Participants
  organizer_id?: string;
  attendees?: Array<{
    email: string;
    status: string;
    name?: string;
  }>;

  // Tracking
  created_by?: string;
  created_at: Date;
  updated_at: Date;
  deleted_at?: Date;
}

// ============================================
// MESSAGE
// ============================================

export interface Message {
  id: string;
  lead_id: string;

  // Channel info
  channel: MessageChannel;
  direction: MessageDirection;
  external_id?: string;

  // Content
  body?: string;
  attachments?: Array<{
    type: string;
    url: string;
    filename?: string;
    size?: number;
  }>;

  // Status
  status: string;
  error_message?: string;

  // Tracking
  sent_by?: string;
  timestamp: Date;
  read_at?: Date;
  created_at: Date;
}

// ============================================
// ACTIVITY (Audit Log)
// ============================================

export interface Activity {
  id: string;
  lead_id?: string;

  // Activity info
  type: ActivityType;
  title?: string;
  description?: string;
  payload?: Record<string, any>;

  // Tracking
  created_by?: string;
  created_at: Date;
  is_important: boolean;
}

// ============================================
// TASK
// ============================================

export interface Task {
  id: string;
  lead_id?: string;

  // Task info
  title: string;
  description?: string;
  due_at?: Date;
  priority: number; // 1-5

  // Status
  status: TaskStatus;
  completed_at?: Date;

  // Assignment
  assignee_id?: string;
  created_by?: string;

  // Tracking
  created_at: Date;
  updated_at: Date;
  deleted_at?: Date;
}

// ============================================
// INTEGRATION
// ============================================

export interface Integration {
  id: string;
  user_id: string;

  // Integration info
  vendor: IntegrationVendor;
  account_id?: string;
  account_name?: string;

  // Credentials (encrypted)
  credentials: Record<string, any>;

  // Status
  status: string;
  last_sync_at?: Date;
  error_message?: string;

  // Metadata
  meta?: Record<string, any>;

  // Tracking
  created_at: Date;
  updated_at: Date;
}

// ============================================
// TEMPLATE
// ============================================

export interface Template {
  id: string;

  // Template info
  type: TemplateType;
  name: string;
  description?: string;

  // Content
  content: string;
  variables?: string[];

  // WhatsApp specific
  whatsapp_template_id?: string;
  whatsapp_category?: string;
  whatsapp_language?: string;
  approved: boolean;

  // Metadata
  locale: string;
  tags?: string[];
  usage_count: number;

  // Tracking
  created_by?: string;
  created_at: Date;
  updated_at: Date;
  deleted_at?: Date;
}

// ============================================
// NOTIFICATION
// ============================================

export interface Notification {
  id: string;
  user_id: string;

  // Notification info
  title: string;
  message: string;
  type: string;

  // Link/Action
  action_url?: string;
  action_label?: string;

  // Related entities
  lead_id?: string;
  event_id?: string;
  task_id?: string;

  // Status
  read: boolean;
  read_at?: Date;

  created_at: Date;
}

// ============================================
// WEBHOOK LOG
// ============================================

export interface WebhookLog {
  id: string;
  vendor: IntegrationVendor;
  event_type: string;
  payload: Record<string, any>;
  headers?: Record<string, any>;
  processed: boolean;
  error_message?: string;
  created_at: Date;
}

// ============================================
// DASHBOARD METRICS
// ============================================

export interface DashboardMetrics {
  owner_id?: string;
  pipeline_id?: string;
  date: Date;
  new_leads_30d: number;
  won_30d: number;
  lost_30d: number;
  revenue_30d: number;
  avg_deal_value: number;
  events_scheduled_30d: number;
  events_completed_30d: number;
  no_shows_30d: number;
}

// ============================================
// API RESPONSES
// ============================================

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T = any> {
  data: T[];
  pagination: {
    page: number;
    per_page: number;
    total: number;
    total_pages: number;
  };
}

// ============================================
// FILTERS & PARAMS
// ============================================

export interface LeadFilters {
  search?: string;
  stage_id?: string;
  owner_id?: string;
  disc_profile?: DISCProfile;
  source?: LeadSource;
  tags?: string[];
  min_value?: number;
  max_value?: number;
  created_after?: Date;
  created_before?: Date;
  sort_by?: 'created_at' | 'updated_at' | 'deal_value' | 'last_activity_at';
  sort_order?: 'asc' | 'desc';
  page?: number;
  per_page?: number;
}

export interface DashboardFilters {
  start_date: Date;
  end_date: Date;
  owner_id?: string;
  pipeline_id?: string;
}

// ============================================
// WEBSOCKET EVENTS
// ============================================

export type WebSocketEvent =
  | {
      type: 'lead_updated';
      pipelineId: string;
      leadId: string;
      data: Partial<Lead>;
    }
  | {
      type: 'lead_moved';
      pipelineId: string;
      leadId: string;
      fromStageId: string;
      toStageId: string;
    }
  | {
      type: 'message_received';
      leadId: string;
      message: Message;
    }
  | {
      type: 'notification';
      userId: string;
      notification: Notification;
    };

// ============================================
// FORM SCHEMAS (para validação)
// ============================================

export interface CreateLeadInput {
  name: string;
  email?: string;
  phone?: string;
  instagram_handle?: string;
  company?: string;
  pipeline_id: string;
  stage_id: string;
  owner_id?: string;
  source: LeadSource;
  disc_profile?: DISCProfile;
  deal_value?: number;
  notes?: string;
  tags?: string[];
}

export interface UpdateLeadInput {
  name?: string;
  email?: string;
  phone?: string;
  instagram_handle?: string;
  company?: string;
  owner_id?: string;
  disc_profile?: DISCProfile;
  deal_value?: number;
  probability?: number;
  expected_close_date?: Date;
  notes?: string;
  tags?: string[];
  custom_fields?: Record<string, any>;
}

export interface MoveLeadInput {
  lead_id: string;
  from_stage_id: string;
  to_stage_id: string;
}

export interface CreateEventInput {
  lead_id: string;
  title: string;
  description?: string;
  start_time: Date;
  end_time: Date;
  location?: string;
  attendees?: string[]; // emails
}

export interface UpdateEventInput {
  title?: string;
  description?: string;
  start_time?: Date;
  end_time?: Date;
  location?: string;
  status?: EventStatus;
  outcome?: CallOutcome;
  outcome_notes?: string;
}

export interface SendMessageInput {
  lead_id: string;
  channel: MessageChannel;
  body: string;
  template_id?: string;
  template_variables?: Record<string, string>;
}

export interface CreateTaskInput {
  lead_id?: string;
  title: string;
  description?: string;
  due_at?: Date;
  priority?: number;
  assignee_id?: string;
}

// ============================================
// HOOKS RETURN TYPES
// ============================================

export interface UseKanbanReturn {
  stages: Stage[];
  leads: Lead[];
  loading: boolean;
  error: string | null;
  moveLead: (
    leadId: string,
    fromStageId: string,
    toStageId: string
  ) => Promise<void>;
  refreshData: () => Promise<void>;
}

export interface UseMessagesReturn {
  messages: Message[];
  loading: boolean;
  error: string | null;
  sendMessage: (input: SendMessageInput) => Promise<void>;
  markAsRead: (messageId: string) => Promise<void>;
  refreshMessages: () => Promise<void>;
}

export interface UseCalendarReturn {
  events: Event[];
  loading: boolean;
  error: string | null;
  createEvent: (input: CreateEventInput) => Promise<Event>;
  updateEvent: (eventId: string, input: UpdateEventInput) => Promise<Event>;
  deleteEvent: (eventId: string) => Promise<void>;
  refreshEvents: () => Promise<void>;
}

// ============================================
// UTILITY TYPES
// ============================================

export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

export type Nullable<T> = T | null;

export type Optional<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>;
