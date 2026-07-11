import { AiAuditClient } from "@/components/AiAuditClient";
import { serverFetch } from "@/lib/serverApi";

export const revalidate = 60;


export const metadata = { title: "AI Audit | Hermina CRM", description: "Hermina CRM AI Audit" };

export default async function Page({ searchParams }: { searchParams: Promise<{ [key: string]: string | string[] | undefined }> }) {
  const page = (await searchParams).page || "1";
  const search = (await searchParams).search || "";
  
  let initialData: unknown = [];
  try {
    initialData = await serverFetch(`/ping`);
  } catch (e) {
    console.error(e);
  }

  return <><h1 className="sr-only">{metadata.title as string}</h1><AiAuditClient initialData={initialData} searchParams={await searchParams} /></>;
}
