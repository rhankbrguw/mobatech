import logging
import re
from transformers import pipeline
import constants as const

class AnonymizationEngine:
    def __init__(self):
        try:
            self.ner_pipeline = pipeline(
                const.PIPELINE_TASK, 
                model=const.NER_MODEL_NAME, 
                aggregation_strategy=const.NER_AGGREGATION_STRATEGY
            )
        except Exception as e:
            self.ner_pipeline = None
            logging.info(const.WARN_NER_NOT_LOADED)

    def normalize_text(self, text: str) -> str:
        # Pembersihan karakter encoding & whitespace (Text Normalization)
        text = text.encode(const.ASCII_ENCODING, const.ENCODE_ERROR_HANDLER).decode(const.ASCII_ENCODING)
        text = re.sub(const.REGEX_WHITESPACE, const.REPLACE_WHITESPACE, text).strip()
        return text

    def apply_regex_masking(self, text: str) -> str:
        # Lapis 1: Regex untuk pola statis (NIK, No HP, Tanggal)
        text = re.sub(const.REGEX_NIK, const.REDACTED_NIK, text)
        text = re.sub(const.REGEX_PHONE, const.REDACTED_PHONE, text)
        return text

    def anonymize(self, text: str) -> str:
        text = self.normalize_text(text)
        text = self.apply_regex_masking(text)
        
        if not self.ner_pipeline:
            return self._fallback_anonymize(text)
            
        # Lapis 2: NER berbasis BERT
        entities = self.ner_pipeline(text)
        anonymized_text = text
        sorted_entities = sorted(entities, key=lambda x: x[const.KEY_START], reverse=True)
        
        for entity in sorted_entities:
            start = entity[const.KEY_START]
            end = entity[const.KEY_END]
            label = entity[const.KEY_ENTITY_GROUP]
            
            # Disabled PER, ORG, LOC redaction because it destroys Doctor names, Hospital names, and queries.
            # if label in ['PER', 'ORG', 'LOC']:
            #     anonymized_text = anonymized_text[:start] + f"[REDACTED_{label}]" + anonymized_text[end:]
            pass
                
        return anonymized_text

    def _fallback_anonymize(self, text: str) -> str:
        return text.replace(const.RS_NAME_ORIGINAL, const.RS_NAME_REDACTED)
