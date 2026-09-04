"use client";

import { useUsersClient } from "@/hooks/useUsersClient";
import { ForbiddenView } from "@/components/ui/ForbiddenView";
import { Card } from "@/components/ui/Card";
import { Plus } from "lucide-react";
import { Pagination } from "@/components/ui/Pagination";
import { APP_STRINGS } from "@/constants";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/Button";
import { UsersTable } from "./UsersTable";
import { UsersHeaderControls } from "./users/UsersHeaderControls";
import { UsersModals } from "./users/UsersModals";

export function UsersClient() {
  const u = useUsersClient();

  if (u.role !== "admin") return <ForbiddenView />;

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title={APP_STRINGS.users.title}
        description={APP_STRINGS.users.subtitle}
        action={
          <Button onClick={() => { u.setEditingUser(null); u.setShowModal(true); }} icon={<Plus size={18} />}>
            {APP_STRINGS.users.addBtn}
          </Button>
        }
      />

      <UsersHeaderControls
        roleFilter={u.roleFilter}
        onRoleFilterChange={u.setRoleFilter}
        searchQuery={u.searchQuery}
        onSearchQueryChange={u.setSearchQuery}
      />

      <Card noPadding>
        <UsersTable 
          users={u.users} 
          loading={u.loading} 
          authUser={u.authUser}
          onView={(user) => { u.setViewingUser(user); u.setIsDrawerOpen(true); }}
          onEdit={(user) => { u.setEditingUser(user); u.setShowModal(true); }}
          onDelete={(id, name) => u.setDeleteConfirm({ id, title: `Hapus pengguna "${name}"?` })}
        />
      </Card>

      <Pagination currentPage={u.currentPage} totalPages={u.totalPages} onPageChange={u.setCurrentPage} />

      <UsersModals
        showModal={u.showModal}
        onCloseModal={() => u.setShowModal(false)}
        editingUser={u.editingUser}
        loadUsers={u.loadUsers}
        deleteConfirm={u.deleteConfirm}
        onCloseDeleteConfirm={() => u.setDeleteConfirm(null)}
        handleDelete={u.handleDelete}
        isDrawerOpen={u.isDrawerOpen}
        onCloseDrawer={() => u.setIsDrawerOpen(false)}
        viewingUser={u.viewingUser}
        toast={u.toast}
        setToast={u.setToast}
      />
    </div>
  );
}
