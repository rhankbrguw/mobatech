import { useState } from "react";
import { useAuthStore } from "@/store/useAuthStore";
import { Polyclinic } from "@/types/api";
import { usePolyclinicsData } from "./usePolyclinicsData";
import { usePolyclinicsActions } from "./usePolyclinicsActions";

export function usePolyclinicsLogic() {
  const user = useAuthStore((state) => state.user);
  const role = user?.role || "admin";
  const [drawerItem, setDrawerItem] = useState<Polyclinic | null>(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);

  const data = usePolyclinicsData();
  const actions = usePolyclinicsActions({ loadItems: async () => { await data.loadItems(); }, setToast: data.setToast });

  return {
    role,
    drawerItem,
    setDrawerItem,
    isDrawerOpen,
    setIsDrawerOpen,
    ...data,
    ...actions,
  };
}
