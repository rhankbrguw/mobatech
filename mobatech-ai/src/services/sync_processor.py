import constants as const


def process_polyclinics(
    polyclinics: tuple, start_id: int
) -> tuple[list[dict[str, object]], int]:
    knowledge: list[dict[str, object]] = []
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
) -> tuple[list[dict[str, object]], int]:
    knowledge: list[dict[str, object]] = []
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


def process_doctors(
    doctors: tuple, start_id: int
) -> tuple[list[dict[str, object]], int]:
    knowledge: list[dict[str, object]] = []
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


def _format_schedule_date(d: object) -> str:
    if hasattr(d, "strftime"):
        return d.strftime(const.DATE_FORMAT_STR)
    return str(d)[: const.DATE_STR_LEN]


def process_schedules(
    schedules: tuple, doc_map: dict[str, dict[str, object]], start_id: int
) -> tuple[list[dict[str, object]], int]:
    knowledge: list[dict[str, object]] = []
    for sched in schedules:
        doc = doc_map.get(sched[const.KEY_DOCTOR_ID])
        if not doc:
            continue

        date_str = _format_schedule_date(sched[const.KEY_DATE])
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
) -> list[dict[str, object]]:
    knowledge: list[dict[str, object]] = []
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
