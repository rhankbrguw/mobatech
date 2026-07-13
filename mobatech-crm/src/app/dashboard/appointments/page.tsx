import { AppointmentsClient } from "@/components/AppointmentsClient";
import { serverFetch } from "@/lib/serverApi";

export const revalidate = 60;


export const metadata = { title: "Manajemen Reservasi | Hermina CRM", description: "Hermina CRM Manajemen Reservasi" };

export default async function Page({ searchParams }: { searchParams: Promise<{ [key: string]: string | string[] | undefined }> }) {
  const page = (await searchParams).page || "1";
  const search = (await searchParams).search || "";
  
  let initialData: unknown = [];
  try {
    initialData = await serverFetch(`/api/admin/appointments?page=${page}&search=${search}`);
  } catch (e) {
    /* ignored */
  }

  return <><h1 className="sr-only">{metadata.title as string}</h1><AppointmentsClient initialData={initialData} searchParams={await searchParams} /></>;
}
