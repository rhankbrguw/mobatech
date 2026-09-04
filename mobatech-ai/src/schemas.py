from typing import Generic, TypeVar, Optional
from pydantic import BaseModel

T = TypeVar("T")


class ApiResponse(BaseModel, Generic[T]):
    success: bool
    code: str
    message: str
    data: Optional[T] = None


class PromptRequest(BaseModel):
    query: str


class RAGResponseData(BaseModel):
    anonymized_query: str
    context: list[str]


class ChatResponseData(BaseModel):
    query: str
    answer: str
    context_used: int
