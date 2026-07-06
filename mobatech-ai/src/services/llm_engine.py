import os
import google.generativeai as genai
from dotenv import load_dotenv
import datetime
import locale
import constants as const

backend_env_path = os.path.join(os.path.dirname(__file__), const.LLM_BACKEND_ENV_PATH_REL)
load_dotenv(backend_env_path)
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

if GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)
    
class GenerativeEngine:
    def __init__(self):
        # We use gemini-1.5-pro or gemini-1.5-flash
        self.model = genai.GenerativeModel(const.GEMINI_MODEL_NAME)
        
    def generate_response(self, query: str, contexts: list[str]) -> str:
        if not GEMINI_API_KEY:
            return const.ERR_LLM_OFFLINE
            
        context_str = "\n".join([f"- {c}" for c in contexts])
        
        # Inject Temporal Context
        try: locale.setlocale(locale.LC_TIME, const.LOCALE_ID)
        except: pass
        
        current_time_str = datetime.datetime.now().strftime(const.TIME_FORMAT)
        
        prompt = const.PROMPT_TEMPLATE.format(
            current_time_str=current_time_str, 
            context_str=context_str, 
            query=query
        )
        
        try:
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            return const.ERR_LLM_EXCEPTION.format(error=str(e))
