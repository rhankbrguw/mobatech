import { PatientsClient } from "@/components/PatientsClient";
import { serverFetch } from "@/lib/serverApi";

export const revalidate = 60;


export const metadata = { title: "Manajemen Pasien | Hermina CRM", description: "Hermina CRM Manajemen Pasien" };

export default async function Page({ searchParams }: { searchParams: Promise<{ [key: string]: string | string[] | undefined }> }) {
  const page = (await searchParams).page || "1";
  const search = (await searchParams).search || "";
  
  let initialData: unknown = [];
  try {
    initialData = await serverFetch(`/api/admin/users?page=${page}&search=${search}`);
  } catch (e) {
    /* ignored */
  }

  return <><h1 className="sr-only">{metadata.title as string}</h1><PatientsClient initialData={initialData} searchParams={await searchParams} /></>;
}
