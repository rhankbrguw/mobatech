import { UsersFormModal } from "../UsersFormModal";
import { DeleteModal } from "@/components/DeleteModal";
import { UserDetailView } from "../UserDetailView";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { User } from "@/types/api";

interface UsersModalsProps {
  showModal: boolean;
  onCloseModal: () => void;
  editingUser: Partial<User> | null;
  loadUsers: () => void;
  deleteConfirm: { id: number; title: string } | null;
  onCloseDeleteConfirm: () => void;
  handleDelete: () => void;
  isDrawerOpen: boolean;
  onCloseDrawer: () => void;
  viewingUser: User | null;
  toast: { isOpen: boolean; message: string; type: "success" | "error" };
  setToast: React.Dispatch<React.SetStateAction<{ isOpen: boolean; message: string; type: "success" | "error" }>>;
}

export function UsersModals({
  showModal, onCloseModal, editingUser, loadUsers,
  deleteConfirm, onCloseDeleteConfirm, handleDelete,
  isDrawerOpen, onCloseDrawer, viewingUser,
  toast, setToast,
}: UsersModalsProps) {
  return (
    <>
      <UsersFormModal isOpen={showModal} onClose={onCloseModal} user={editingUser} onSuccess={loadUsers} setToast={setToast} />
      <DeleteModal isOpen={!!deleteConfirm} onClose={onCloseDeleteConfirm} onConfirm={handleDelete} description={deleteConfirm?.title} />
      <UserDetailView isOpen={isDrawerOpen} onClose={onCloseDrawer} user={viewingUser} />
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </>
  );
}
