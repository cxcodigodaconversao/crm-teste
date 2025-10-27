export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24 bg-[#0c121c]">
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm">
        <h1 className="text-4xl font-bold text-center text-[#d2bc8f] mb-8">
          🎯 CRM Conversão
        </h1>
        <p className="text-center text-gray-400 mb-8">
          Sistema de CRM focado em conversão real
        </p>
        <div className="flex justify-center gap-4">
          <a
            href="/crm"
            className="px-6 py-3 bg-[#d2bc8f] text-[#0c121c] rounded-lg font-semibold hover:bg-[#e6d0a3] transition-colors"
          >
            Ir para CRM →
          </a>
        </div>
      </div>
    </main>
  )
}
