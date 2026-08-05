import { useState, useEffect } from 'react'
import { Prompt, PromptRequest } from './types'
import { promptApi } from './api/promptApi'
import PromptList from './components/PromptList'
import PromptEditor from './components/PromptEditor'

function App() {
  const [prompts, setPrompts] = useState<Prompt[]>([])
  const [isAdding, setIsAdding] = useState(false)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const fetchPrompts = async () => {
    try {
      setLoading(true)
      const data = await promptApi.getAllPrompts()
      setPrompts(data)
      setError(null)
    } catch (err: any) {
      setError(err.message || 'Failed to fetch prompts')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchPrompts()
  }, [])

  const handleCreatePrompt = async (request: PromptRequest) => {
    try {
      await promptApi.createPrompt(request)
      setIsAdding(false)
      fetchPrompts()
    } catch (err: any) {
      alert(err.message)
    }
  }

  const handleDeletePrompt = async (id: string) => {
    if (window.confirm('Are you sure you want to delete this prompt?')) {
      try {
        await promptApi.deletePrompt(id)
        fetchPrompts()
      } catch (err: any) {
        alert(err.message)
      }
    }
  }

  if (loading) return <div>Loading prompts...</div>

  return (
    <div style={{ maxWidth: '1000px', margin: '0 auto', padding: '2rem' }}>
      <header style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h1>Prompter</h1>
        {!isAdding && (
          <button onClick={() => setIsAdding(true)}>Add New Prompt</button>
        )}
      </header>

      {error && (
        <div style={{ color: 'red', marginBottom: '1rem' }}>
          <strong>Error:</strong> {error}
        </div>
      )}

      {isAdding ? (
        <PromptEditor
          onSubmit={handleCreatePrompt}
          onCancel={() => setIsAdding(false)}
        />
      ) : (
        <PromptList prompts={prompts} onDelete={handleDeletePrompt} />
      )}
    </div>
  )
}

export default App
