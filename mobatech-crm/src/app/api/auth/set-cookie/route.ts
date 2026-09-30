import { NextResponse } from "next/server";
import { APP_STRINGS } from "@/constants";

export async function POST(request: Request) {
  try {
    const body = await request.json().catch(() => null);

    if (!body || typeof body.token !== "string" || !body.token.trim()) {
      return NextResponse.json(
        {
          success: false,
          code: "INVALID_PAYLOAD",
          message: "Authentication token is required",
          error: "Token field is missing or empty",
          data: null,
        },
        { status: 400 }
      );
    }

    const { token } = body;
    const response = NextResponse.json({
      success: true,
      code: "COOKIE_SET_SUCCESS",
      message: "Authentication cookie set successfully",
      data: null,
    });

    response.cookies.set({
      name: "auth_token",
      value: token,
      httpOnly: true,
      path: "/",
      secure: process.env.NODE_ENV === "production",
      maxAge: 60 * 60 * 24 * 7, // 1 week
    });

    return response;
  } catch (err: unknown) {
    const errorMessage = err instanceof Error ? err.message : APP_STRINGS.errors.INTERNAL_ERROR;
    return NextResponse.json(
      {
        success: false,
        code: "INTERNAL_ERROR",
        message: APP_STRINGS.errors.INTERNAL_ERROR,
        error: errorMessage,
        data: null,
      },
      { status: 500 }
    );
  }
}

