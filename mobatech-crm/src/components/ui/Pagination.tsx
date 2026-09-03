"use client";
import { Button } from "./Button";
import { ChevronLeft, ChevronRight } from "lucide-react";

interface PaginationProps {
  currentPage: number;
  totalPages: number;
  onPageChange: (page: number) => void;
}

export function Pagination({ currentPage, totalPages, onPageChange }: PaginationProps) {
  if (totalPages <= 1) return null;

  const getVisiblePages = () => {
    if (totalPages <= 7) return Array.from({ length: totalPages }, (_, i) => i + 1);
    
    if (currentPage <= 4) return [1, 2, 3, 4, 5, "...", totalPages];
    if (currentPage >= totalPages - 3) return [1, "...", totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
    
    return [1, "...", currentPage - 1, currentPage, currentPage + 1, "...", totalPages];
  };

  const visiblePages = getVisiblePages();

  return (
    <div className="flex items-center justify-center gap-2 mt-6 glass-panel p-2 rounded-2xl w-max mx-auto shadow-sm animate-slide-in">
      <Button variant="outline" size="sm" disabled={currentPage === 1} onClick={() => onPageChange(currentPage - 1)} className="h-9 w-9 p-0 rounded-xl">
        <ChevronLeft size={16} />
      </Button>
      <div className="flex items-center gap-1">
        {visiblePages.map((page, idx) => (
          typeof page === "number" ? (
            <Button
              key={`page-${page}-${idx}`}
              variant={page === currentPage ? "primary" : "ghost"}
              size="sm"
              onClick={() => onPageChange(page)}
              className={`h-9 w-9 p-0 rounded-xl font-medium transition-all duration-300 ${page === currentPage ? 'shadow-md scale-105' : 'hover:bg-overlay-dark dark:hover:bg-overlay-light'}`}
            >
              {page}
            </Button>
          ) : (
            <span key={`ellipsis-${idx}`} className="px-1 text-foreground/50 text-sm">...</span>
          )
        ))}
      </div>
      <Button variant="outline" size="sm" disabled={currentPage === totalPages} onClick={() => onPageChange(currentPage + 1)} className="h-9 w-9 p-0 rounded-xl">
        <ChevronRight size={16} />
      </Button>
    </div>
  );
}
