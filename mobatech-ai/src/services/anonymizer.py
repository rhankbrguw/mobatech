import logging
import re
from transformers import pipeline
from typing import Optional
import constants as const


class AnonymizationEngine:
    def __init__(self) -> None:
        self.ner_pipeline: Optional[object] = None
        try:
            self.ner_pipeline = pipeline(
                "ner",
                model=const.NER_MODEL_NAME,
                aggregation_strategy=const.NER_AGGREGATION_STRATEGY,
            )
        except (OSError, RuntimeError) as e:
            logging.warning(const.ERR_NER_LOAD_FAILED.format(error=str(e)))
            logging.info(const.WARN_NER_NOT_LOADED)

    def normalize_text(self, text: str) -> str:
        text = text.encode(const.ASCII_ENCODING, "ignore").decode(
            const.ASCII_ENCODING
        )
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
        sorted_entities = sorted(
            entities, key=lambda x: x["start"], reverse=True
        )
        for entity in sorted_entities:
            start = entity["start"]
            end = entity["end"]
            # Use a generic redacted tag or const if available, falling back to [REDACTED]
            redacted_tag = getattr(const, "REDACTED_NER", "[REDACTED]")
            anonymized_text = anonymized_text[:start] + redacted_tag + anonymized_text[end:]

        return anonymized_text

    def _fallback_anonymize(self, text: str) -> str:
        return text.replace(const.RS_NAME_ORIGINAL, const.RS_NAME_REDACTED)
