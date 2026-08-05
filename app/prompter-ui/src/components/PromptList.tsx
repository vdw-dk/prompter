import React from 'react';
import { Prompt } from '../types';

interface Props {
  prompts: Prompt[];
  onDelete: (id: string) => void;
}

const PromptList: React.FC<Props> = ({ prompts, onDelete }) => {
  return (
    <div>
      <h2>Prompts</h2>
      {prompts.length === 0 ? (
        <p>No prompts found.</p>
      ) : (
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr style={{ textAlign: 'left', borderBottom: '2px solid #eee' }}>
              <th>Name</th>
              <th>Version</th>
              <th>Description</th>
              <th>Created</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {prompts.map((prompt) => (
              <tr key={prompt.id} style={{ borderBottom: '1px solid #eee' }}>
                <td>{prompt.name}</td>
                <td>{prompt.version}</td>
                <td>{prompt.description}</td>
                <td>{new Date(prompt.createdAt).toLocaleString()}</td>
                <td>
                  <button
                    onClick={() => onDelete(prompt.id)}
                    style={{ color: 'red', cursor: 'pointer' }}
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default PromptList;
