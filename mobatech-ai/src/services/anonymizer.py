import logging
import re
from transformers import pipeline
from typing import Any, Optional
import constants as const

class AnonymizationEngine:
    def __init__(self) -> None:
        self.ner_pipeline: Optional[Any] = None
        try:
            self.ner_pipeline = pipeline(
                const.PIPELINE_TASK, 
                model=const.NER_MODEL_NAME, 
                aggregation_strategy=const.NER_AGGREGATION_STRATEGY
            )
        except Exception as e:
            logging.warning(const.ERR_NER_LOAD_FAILED.format(error=str(e)))
            logging.info(const.WARN_NER_NOT_LOADED)

    def normalize_text(self, text: str) -> str:
        text = text.encode(const.ASCII_ENCODING, const.ENCODE_ERROR_HANDLER).decode(const.ASCII_ENCODING)
        text = re.sub(const.REGEX_WHITESPACE, const.REPLACE_WHITESPACE, text).strip()
        return text

    def apply_regex_masking(self, text: str) -> str:
        text = re.sub(const.REGEX_NIK, const.REDACTED_NIK, text)
        text = re.sub(const.REGEX_PHONE, const.REDACTED_PHONE, text)
        return text

    def anonymize(self, text: str) -> str:
        text = self.normalize_text(text)
        text = self.apply_regex_masking(text)
        
        if not self.ner_pipeline:
            return self._fallback_anonymize(text)
            
        entities = self.ner_pipeline(text)
        anonymized_text = text
        sorted_entities = sorted(entities, key=lambda x: x[const.KEY_START], reverse=True)
        
        for entity in sorted_entities:
            # In future, we can add more logic here. Currently disabled PER, ORG, LOC
            pass
                
        return anonymized_text

    def _fallback_anonymize(self, text: str) -> str:
        return text.replace(const.RS_NAME_ORIGINAL, const.RS_NAME_REDACTED)
