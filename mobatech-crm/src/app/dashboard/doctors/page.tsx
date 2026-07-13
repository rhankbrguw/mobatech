import { DoctorsClient } from "@/components/DoctorsClient";
import { serverFetch } from "@/lib/serverApi";

export const revalidate = 60;


export const metadata = { title: "Manajemen Dokter | Hermina CRM", description: "Hermina CRM Manajemen Dokter" };

export default async function Page({ searchParams }: { searchParams: Promise<{ [key: string]: string | string[] | undefined }> }) {
  const page = (await searchParams).page || "1";
  const search = (await searchParams).search || "";
  
  let initialData: unknown = [];
  try {
    initialData = await serverFetch(`/api/doctors?page=${page}&search=${search}`);
  } catch (e) {
    /* ignored */
  }

  return <><h1 className="sr-only">{metadata.title as string}</h1><DoctorsClient initialData={initialData} searchParams={await searchParams} /></>;
}
