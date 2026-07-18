from typing import Any
import constants as const


def process_polyclinics(
    polyclinics: tuple, start_id: int
) -> tuple[list[dict[str, Any]], int]:
    knowledge: list[dict[str, Any]] = []
    for poly in polyclinics:
        t = const.TEMPLATE_POLY.format(
            name=poly[const.KEY_NAME], description=poly[const.KEY_DESCRIPTION]
        )
        knowledge.append(
            {
                const.KEY_ID: start_id,
                const.KEY_KATEGORI: const.CAT_LAYANAN,
                const.KEY_TEKS: t,
            }
        )
        start_id += 1
    return knowledge, start_id


def process_branches(
    branches: tuple, start_id: int
) -> tuple[list[dict[str, Any]], int]:
    knowledge: list[dict[str, Any]] = []
    for branch in branches:
        t = const.TEMPLATE_BRANCH.format(
            name=branch[const.KEY_NAME],
            address=branch[const.KEY_ADDRESS],
            link=branch[const.KEY_GMAPS_LINK],
        )
        knowledge.append(
            {
                const.KEY_ID: start_id,
                const.KEY_KATEGORI: const.CAT_CABANG,
                const.KEY_TEKS: t,
            }
        )
        start_id += 1
    return knowledge, start_id


def process_doctors(doctors: tuple, start_id: int) -> tuple[list[dict[str, Any]], int]:
    knowledge: list[dict[str, Any]] = []
    for doc in doctors:
        t = const.TEMPLATE_DOCTOR.format(
            name=doc[const.KEY_NAME],
            spec=doc[const.KEY_SPECIALIZATION],
            desc=doc[const.KEY_DESCRIPTION],
        )
        knowledge.append(
            {
                const.KEY_ID: start_id,
                const.KEY_KATEGORI: const.CAT_DOKTER,
                const.KEY_TEKS: t,
            }
        )
        start_id += 1
    return knowledge, start_id


def process_schedules(
    schedules: tuple, doc_map: dict[str, Any], start_id: int
) -> tuple[list[dict[str, Any]], int]:
    knowledge: list[dict[str, Any]] = []
    for sched in schedules:
        doc = doc_map.get(sched[const.KEY_DOCTOR_ID])
        if not doc:
            continue

        d = sched[const.KEY_DATE]
        date_str = (
            d.strftime(const.DATE_FORMAT_STR)
            if hasattr(d, "strftime")
            else str(d)[: const.DATE_STR_LEN]
        )
        q = sched[const.KEY_QUOTA] - sched[const.KEY_BOOKED]
        t = const.TEMPLATE_SCHEDULE.format(
            name=doc[const.KEY_NAME],
            spec=doc[const.KEY_SPECIALIZATION],
            date=date_str,
            start=sched[const.KEY_START_TIME],
            end=sched[const.KEY_END_TIME],
            quota=q,
        )
        knowledge.append(
            {
                const.KEY_ID: start_id,
                const.KEY_KATEGORI: const.CAT_JADWAL,
                const.KEY_TEKS: t,
            }
        )
        start_id += 1
    return knowledge, start_id


def process_dynamic_knowledge(
    doctors: tuple, schedules: tuple, polyclinics: tuple, branches: tuple
) -> list[dict[str, Any]]:
    knowledge: list[dict[str, Any]] = []
    row_id = const.KNOWLEDGE_START_ID
    doc_map = {d[const.KEY_ID]: d for d in doctors}

    k_poly, row_id = process_polyclinics(polyclinics, row_id)
    knowledge.extend(k_poly)

    k_branch, row_id = process_branches(branches, row_id)
    knowledge.extend(k_branch)

    k_doc, row_id = process_doctors(doctors, row_id)
    knowledge.extend(k_doc)

    k_sched, row_id = process_schedules(schedules, doc_map, row_id)
    knowledge.extend(k_sched)

    return knowledge
