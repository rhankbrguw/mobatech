import { MedicalResultsClient } from "@/components/MedicalResultsClient";
import { serverFetch } from "@/lib/serverApi";

export const revalidate = 60; // Cache for 60 seconds (ISR)


export const metadata = { title: "Hasil Medis | Hermina CRM", description: "Hermina CRM Hasil Medis" };

export default async function Page({ searchParams }: { searchParams: Promise<{ [key: string]: string | string[] | undefined }> }) {
  const page = (await searchParams).page || "1";
  const search = (await searchParams).search || "";
  
  // Example fetch, customize per page
  let initialData: unknown = [];
  try {
    initialData = await serverFetch(`/api/admin/medical-results?page=${page}&search=${search}`);
  } catch (e) {
    console.error(e);
  }

  return <><h1 className="sr-only">{metadata.title as string}</h1><MedicalResultsClient initialData={initialData} searchParams={await searchParams} /></>;
}
