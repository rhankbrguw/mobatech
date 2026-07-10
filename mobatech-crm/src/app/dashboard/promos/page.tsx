import { PromosClient } from "@/components/PromosClient";
export const metadata = { title: "Manajemen Promo | Hermina CRM" };
export default function Page() { return <><h1 className="sr-only">{metadata.title as string}</h1><PromosClient /></>; }
