// app/page.tsx
'use client'

import { generateClient } from 'aws-amplify/data'
import { Schema } from '@data-schema'
import { useEffect, useState } from 'react'
import Pagination from './Pagination'

const client = generateClient<Schema>()

type Account = Schema["Account"]['type'];

export default function Home() {
  const [items, setItems] = useState<Account[]>([])
  const [nextToken, setNextToken] = useState<string | null>(null)
  const [previousTokens, setPreviousTokens] = useState<string[]>([])

  const fetchItems = async (token: string | null = null) => {
    const response = await client.models.Account.list({
      limit: 10,
      nextToken: token || undefined,
    })

    setItems(response.data)
    setNextToken(response.nextToken ?? null)
  }

  const handleNext = () => {
    if (nextToken) {
      setPreviousTokens((prev) => [...prev, nextToken])
      fetchItems(nextToken)
    }
  }

  const handlePrev = () => {
    const prev = [...previousTokens]
    const token = prev.pop()
    setPreviousTokens(prev)
    fetchItems(token ?? null)
  }

  useEffect(() => {
    fetchItems()
  }, [])

  return (
    <div>
      <h1 className="text-xl font-bold mb-4">Items</h1>
      <ul className="space-y-2">
        {items.map((item) => (
          <li key={item.id} className="border rounded p-2">
            {item.number}
          </li>
        ))}
      </ul>

      <Pagination
        onNext={handleNext}
        onPrev={handlePrev}
        hasNext={!!nextToken}
        hasPrev={previousTokens.length > 0}
      />
    </div>
  )
}
