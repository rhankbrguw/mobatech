import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export default async function proxy(request: NextRequest) {
  const token = request.cookies.get('auth_token')?.value;
  const { pathname } = request.nextUrl;

  if (pathname.startsWith('/dashboard')) {
    if (!token) {
      return NextResponse.redirect(new URL('/login', request.url));
    }
    try {
      const verifyRes = await fetch("http://localhost:8080/api/auth/me", {
        headers: { Authorization: `Bearer ${token}` }
      });
      if (!verifyRes.ok) {
        return NextResponse.redirect(new URL('/login', request.url));
      }
      const data = await verifyRes.json();
      if (!data?.data?.role || data.data.role === 'patient') {
        const res = NextResponse.redirect(new URL('/login', request.url));
        res.cookies.delete('auth_token');
        return res;
      }
    } catch {
      return NextResponse.redirect(new URL('/login', request.url));
    }
  }

  if (pathname === '/login' && token) {
    return NextResponse.redirect(new URL('/dashboard', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/login'],
};
