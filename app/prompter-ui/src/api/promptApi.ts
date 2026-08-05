import { Prompt, PromptRequest } from '../types';

const API_BASE_URL = '/api/prompts';

export const promptApi = {
  async getAllPrompts(): Promise<Prompt[]> {
    const response = await fetch(API_BASE_URL);
    if (!response.ok) throw new Error('Failed to fetch prompts');
    return response.json();
  },

  async getPromptById(id: string): Promise<Prompt> {
    const response = await fetch(`${API_BASE_URL}/${id}`);
    if (!response.ok) throw new Error('Failed to fetch prompt');
    return response.json();
  },

  async getPromptsByName(name: string): Promise<Prompt[]> {
    const response = await fetch(`${API_BASE_URL}/name/${name}`);
    if (!response.ok) throw new Error('Failed to fetch prompts by name');
    return response.json();
  },

  async getPromptByNameAndVersion(name: string, version: string): Promise<Prompt> {
    const response = await fetch(`${API_BASE_URL}/name/${name}/version/${version}`);
    if (!response.ok) throw new Error('Failed to fetch prompt by name and version');
    return response.json();
  },

  async createPrompt(prompt: PromptRequest): Promise<Prompt> {
    const response = await fetch(API_BASE_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(prompt),
    });
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'Failed to create prompt');
    }
    return response.json();
  },

  async deletePrompt(id: string): Promise<void> {
    const response = await fetch(`${API_BASE_URL}/${id}`, {
      method: 'DELETE',
    });
    if (!response.ok) throw new Error('Failed to delete prompt');
  },
};
