import { PolyclinicsClient } from "@/components/PolyclinicsClient";
import { serverFetch } from "@/lib/serverApi";

export const revalidate = 60;


export const metadata = { title: "Manajemen Poliklinik | Hermina CRM", description: "Hermina CRM Manajemen Poliklinik" };

export default async function Page({ searchParams }: { searchParams: Promise<{ [key: string]: string | string[] | undefined }> }) {
  const page = (await searchParams).page || "1";
  const search = (await searchParams).search || "";
  
  let initialData: unknown = [];
  try {
    initialData = await serverFetch(`/api/polyclinics?page=${page}&search=${search}`);
  } catch (e) {
    console.error(e);
  }

  return <><h1 className="sr-only">{metadata.title as string}</h1><PolyclinicsClient initialData={initialData} searchParams={await searchParams} /></>;
}
