SELECT *
FROM public.parcing_table
LIMIT 10;


-- 01 Определите диапазон заработных плат в общем, а именно средние значения, 
-- минимумы и максимумы нижних и верхних порогов зарплаты.

SELECT
	MIN(salary_from) AS salary_from_min,
	ROUND(AVG(salary_from), 2) AS salary_from_avg,
	MAX(salary_from) AS salary_from_max,
	MIN(salary_to) AS salary_to_min,
	ROUND(AVG(salary_to), 2) AS salary_to_avg,
	MAX(salary_to) AS salary_to_max
FROM public.parcing_table;

-- salary_from_min|salary_from_avg|salary_from_max|salary_to_min|salary_to_avg|salary_to_max|
-- ---------------+---------------+---------------+-------------+-------------+-------------+
--            50.0|      109525.09|       398000.0|      25000.0|    153846.71|     497500.0|

-- Средняя зарплата в категории «от» составляет около 109 525 рублей, а в категории «до» — около 153 846 рублей. 
-- Это свидетельствует о том, что работодатели в среднем готовы платить аналитикам данных и системным аналитикам 
-- порядка 130 000 рублей.
-- Минимальная предлагаемая зарплата начинается с 50 рублей — вероятнее всего, это ошибка в данных, — 
-- а максимальная достигает 497 500 рублей.


-- 02 Выявите регионы и компании, в которых сосредоточено наибольшее количество вакансий.

-- Количество вакансий по регионам
SELECT 
	area,
    COUNT(*) AS total_vacancies
FROM public.parcing_table
GROUP BY area
ORDER BY COUNT(*) DESC;

-- area                         |total_vacancies|
-- -----------------------------+---------------+
-- Москва                       |           1247|
-- Санкт-Петербург              |            181|
-- Екатеринбург                 |             51|
-- Нижний Новгород              |             33|
-- ...

-- Москва и Санкт-Петербург лидируют по количеству вакансий как крупнейшие города
-- В Екатеринбурге, Нижнем Новгороде также достаточно много вакансий
-- что означает наличие развитого рынка труда для аналитиков данных в этих городах.

-- Количество вакансий по компаниям
SELECT employer,
       COUNT(*) AS total_vacancies 
FROM public.parcing_table 
GROUP BY employer 
ORDER BY COUNT(*) DESC;

-- employer                                                               |total_vacancies|
-- -----------------------------------------------------------------------+---------------+
-- СБЕР                                                                   |            243|
-- WILDBERRIES                                                            |             43|
-- Ozon                                                                   |             34|
-- Банк ВТБ (ПАО)                                                         |             28|
-- Т1                                                                     |             26|
-- ...

-- СБЕР - крупнейший работодатель для аналитиков данных. 
-- Скорее всего это объясняется разносторонним бизнесом компании и значительным объёмом инвестиций в технологическое развитие.
-- WILDBERRIES, Ozon и другие бигтехи также предлагают значительное кол-во вакансий в области данных.


-- 03 Проанализируйте, какие преобладают типы занятости, а также графики работы.

-- Количество вакансий по типу занятости
SELECT employment,
       COUNT(*) AS total_vacancies
FROM public.parcing_table 
GROUP BY employment 
ORDER BY COUNT(*) DESC;

-- employment         |total_vacancies|
-- -------------------+---------------+
-- Полная занятость   |           1764|
-- Частичная занятость|             16|
-- Стажировка         |             16|
-- Проектная работа   |              5|

-- Абсолютное большинство вакансий предполагают полную занятость, что предполагает наличие постоянных позиций.

-- Количество вакансий по графику работы
SELECT schedule,
       COUNT(*) AS total_vacancies 
FROM public.parcing_table 
GROUP BY schedule 
ORDER BY COUNT(*) DESC;

-- schedule        |total_vacancies|
-- ----------------+---------------+
-- Полный день     |           1441|
-- Удаленная работа|            310|
-- Гибкий график   |             41|
-- Сменный график  |              9|

-- Большинство вакансий предлагают работу с полным днём. 
-- Однако вакансий с удалённым графиком работы также значительное количество.


-- 04 Изучите распределение грейдов (Junior, Middle, Senior) среди аналитиков данных и системных аналитиков.

SELECT 
	experience,
	COUNT(id) AS total_vacancies
FROM public.parcing_table
GROUP BY experience
ORDER BY experience;

-- experience           |total_vacancies|
-- ---------------------+---------------+
-- Junior (no experince)|            142|
-- Junior+ (1-3 years)  |           1091|
-- Middle (3-6 years)   |            555|
-- Senior (6+ years)    |             13|

-- Наибольшее количество вакансий предназначено для Junior+ специалистов, т.е. спрос на специалистов начального и среднего уровней. 
-- Вакансий для Middle также много, в то время как спрос на Senior очень низкий. Возможно сказывается рост таких спецалистов внутри компаний
-- или не открытый их поиск.


-- 05 Выявите основных работодателей, предлагаемые зарплаты и условия труда для аналитиков.

SELECT 
	employer,
	salary_from,
	salary_to,
	employment,
	schedule,
	COUNT(id) AS total_vacancies
FROM public.parcing_table
GROUP BY
	employer,
	salary_from,
	salary_to,
	employment,
	schedule
ORDER BY COUNT(id) DESC;

-- employer                                                               |salary_from|salary_to|employment         |schedule        |total_vacancies|
-- -----------------------------------------------------------------------+-----------+---------+-------------------+----------------+---------------+
-- СБЕР                                                                   |           |         |Полная занятость   |Полный день     |            223|
-- WILDBERRIES                                                            |           |         |Полная занятость   |Полный день     |             30|
-- Банк ВТБ (ПАО)                                                         |           |         |Полная занятость   |Полный день     |             28|
-- Ozon                                                                   |           |         |Полная занятость   |Полный день     |             24|
-- Т1                                                                     |           |         |Полная занятость   |Полный день     |             20|
-- ...

-- Как и было выявлено ранее, СБЕР - крупнейший работтодатель и предлагает наибольшее число вакансий для аналитиков.
-- В остальном ТОП по данному запросу очень схож, все работодатели не называют явно зарплатную вилку,
-- и предполагают, что соискатель готов работать с постоянной занятостью полный рабочий день.


-- 06 Определите наиболее востребованные навыки (как жёсткие, так и мягкие) для различных грейдов и позиций.

-- Частота упоминаний key_skills_1
SELECT key_skills_1,
       COUNT(*) AS in_vacancies
FROM public.parcing_table
WHERE key_skills_1 NOT IN ('') AND key_skills_1 IS NOT NULL
GROUP BY key_skills_1 
ORDER BY in_vacancies DESC;

-- Частота упоминаний key_skills_2
SELECT key_skills_2,
       COUNT(*) AS in_vacancies
FROM public.parcing_table
WHERE key_skills_2 NOT IN ('') AND key_skills_1 IS NOT NULL
GROUP BY key_skills_2 
ORDER BY in_vacancies DESC;

-- Частота упоминаний key_skills_3
SELECT key_skills_3,
       COUNT(*) AS in_vacancies
FROM public.parcing_table
WHERE key_skills_3 NOT IN ('') AND key_skills_1 IS NOT NULL
GROUP BY key_skills_3 
ORDER BY in_vacancies DESC;

-- Частота упоминаний key_skills_4
SELECT key_skills_4,
       COUNT(*) AS in_vacancies
FROM public.parcing_table
WHERE key_skills_4 NOT IN ('') AND key_skills_1 IS NOT NULL
GROUP BY key_skills_4 
ORDER BY in_vacancies DESC;

-- Частота упоминаний soft_skills_1
SELECT soft_skills_1,
       COUNT(*) AS in_vacancies
FROM public.parcing_table
WHERE soft_skills_1 NOT IN ('') AND soft_skills_1 IS NOT NULL
GROUP BY soft_skills_1 
ORDER BY in_vacancies DESC;

-- key_skills_1                                                    |in_vacancies|
-- ----------------------------------------------------------------+------------+
-- Анализ данных                                                   |         312|
-- SQL                                                             |         161|
-- Документация                                                    |          89|
-- MS SQL                                                          |          87|
-- Pandas                                                          |          86|
-- Аналитическое мышление                                          |          80|

-- (Аналогично для остальных столбцов key_skills и soft_skills)

-- Среди ключевых навыков чаще остальных упоминаются «Анализ данных», SQL и MS SQL
-- Наличие полей «Документация» в топе свидетельствует о необходимости умения ведения качественных отчётов.