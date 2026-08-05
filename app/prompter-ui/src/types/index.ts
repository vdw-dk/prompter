export interface Prompt {
  id: string;
  name: string;
  version: string;
  content: string;
  description?: string;
  metadata?: Record<string, any>;
  createdAt: string;
  updatedAt: string;
}

export interface PromptRequest {
  name: string;
  version: string;
  content: string;
  description?: string;
  metadata?: Record<string, any>;
}
