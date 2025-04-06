// app/Pagination.tsx
type PaginationProps = {
  onNext: () => void
  onPrev: () => void
  hasNext: boolean
  hasPrev: boolean
}

export default function Pagination({ onNext, onPrev, hasNext, hasPrev }: PaginationProps) {
  return (
    <div className="flex justify-center mt-4 space-x-2">
      <button
        className="px-4 py-2 bg-gray-300 rounded disabled:opacity-50"
        onClick={onPrev}
        disabled={!hasPrev}
      >
        Previous
      </button>
      <button
        className="px-4 py-2 bg-gray-300 rounded disabled:opacity-50"
        onClick={onNext}
        disabled={!hasNext}
      >
        Next
      </button>
    </div>
  )
}
