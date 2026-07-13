import os
import logging
from google import genai
from dotenv import load_dotenv
import datetime
import locale
from typing import Optional
import constants as const

backend_env_path = os.path.join(os.path.dirname(__file__), const.LLM_BACKEND_ENV_PATH_REL)
load_dotenv(backend_env_path)
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
    
class GenerativeEngine:
    def __init__(self) -> None:
        self.client: Optional[genai.Client] = genai.Client(api_key=GEMINI_API_KEY) if GEMINI_API_KEY else None
        
    def generate_response(self, query: str, contexts: list[str]) -> str:
        if not self.client:
            return const.ERR_LLM_OFFLINE
            
        context_str = "\n".join([f"- {c}" for c in contexts])
        
        try: 
            locale.setlocale(locale.LC_TIME, const.LOCALE_ID)
        except locale.Error as e:
            logging.warning(const.ERR_LOCALE_FAILED.format(e=e))
        
        current_time_str = datetime.datetime.now().strftime(const.TIME_FORMAT)
        
        prompt = const.PROMPT_TEMPLATE.format(
            current_time_str=current_time_str, 
            context_str=context_str, 
            query=query
        )
        
        try:
            response = self.client.models.generate_content(
                model=const.GEMINI_MODEL_NAME,
                contents=prompt
            )
            return response.text
        except Exception as e:
            logging.error(const.ERR_LLM_EXCEPTION.format(error=str(e)))
            return const.ERR_LLM_EXCEPTION.format(error=str(e))
