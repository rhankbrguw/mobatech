import os

NER_MODEL_NAME = os.getenv("NER_MODEL_NAME", "cahya/bert-base-indonesian-NER")
NER_AGGREGATION_STRATEGY = "simple"
WARN_NER_NOT_LOADED = "Warning: NER model not loaded. Using fallback regex anonymizer."
ERR_NER_LOAD_FAILED = "Error loading NER model: {error}"
REGEX_NIK = r"\b\d{16}\b"
REGEX_PHONE = r"\b(?:08|\+628)\d{8,11}\b"
REDACTED_NIK = "[REDACTED_NIK]"
REDACTED_PHONE = "[REDACTED_PHONE]"
RS_NAME_ORIGINAL = "Hermina"
RS_NAME_REDACTED = "[RS_NAME]"
ASCII_ENCODING = "ascii"
REGEX_WHITESPACE = r"\s+"
REPLACE_WHITESPACE = " "
