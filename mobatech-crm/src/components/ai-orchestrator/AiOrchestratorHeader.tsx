import { APP_STRINGS } from "@/constants";

export function AiOrchestratorHeader() {
  return (
    <div>
      <h1 className="text-2xl font-bold tracking-tight">{APP_STRINGS.aiOrchestrator.title}</h1>
      <p className="text-foreground/60 text-xs mt-1">{APP_STRINGS.aiOrchestrator.subtitle}</p>
    </div>
  );
}
