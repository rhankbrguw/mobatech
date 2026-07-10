import { EmergenciesClient } from "@/components/EmergenciesClient";
import { serverFetch } from "@/lib/serverApi";

export const revalidate = 60; // Cache for 60 seconds (ISR)


export const metadata = { title: "Manajemen Darurat | Hermina CRM", description: "Hermina CRM Manajemen Darurat" };

export default async function Page({ searchParams }: { searchParams: Promise<{ [key: string]: string | string[] | undefined }> }) {
  const page = (await searchParams).page || "1";
  const search = (await searchParams).search || "";
  
  // Example fetch, customize per page
  let initialData: unknown = [];
  try {
    initialData = await serverFetch(`/api/admin/emergencies?page=${page}&search=${search}`);
  } catch (e) {
    console.error(e);
  }

  return <><h1 className="sr-only">{metadata.title as string}</h1><EmergenciesClient initialData={initialData} searchParams={await searchParams} /></>;
}
