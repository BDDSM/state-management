Функция Модель(Контекст, Знач ПутьКДанным = "") Экспорт
	Если ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения") И ПутьКДанным = "" Тогда
		ПутьКДанным = "Объект";
	КонецЕсли;
	Модель = РаботаСМодельюКлиентСервер.Модель("МодельЗаявкаНаОперацию", ПутьКДанным);

	//  Настройка зависимостей: Зависимый элемент <- Источник
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "ДоговорКонтрагента", "Организация", "Отбор.Организация");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "ДоговорКонтрагента", "Контрагент", "Отбор.Контрагент");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "ВалютаВзаиморасчетов", "ДоговорКонтрагента", "ДоговорКонтрагента");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "ТипОперацииБюджетирование", "ВидОперации", "ВидОперации");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "ПриходРасход", "ВидОперации", "ВидОперации");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "СуммаВзаиморасчетов", "СуммаДокумента", "СуммаДокумента");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "СуммаВзаиморасчетов", "КроссКурс", "КроссКурс");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "ДвиженияОперации.СуммаВзаиморасчетов", "ДвиженияОперации.Сумма", "Сумма",, Новый Структура("Использование", "ЭтоВнешняяОперация"));
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "ДвиженияОперации.СуммаВзаиморасчетов", "КроссКурс", "КроссКурс",, Новый Структура("Использование", "ЭтоВнешняяОперация"));

	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "ЭтоВнутренняяОперация", "ТипОперацииБюджетирование", "ТипОперации");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "ЭтоВнешняяОперация", "ЭтоВнутренняяОперация", "ЭтоВнутренняяОперация");

	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "СчетКонтрагента", "Организация", "Отбор.Владелец",, Новый Структура("Использование", "ЭтоВнутренняяОперация"));
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "СчетКонтрагента", "Контрагент", "Отбор.Владелец",, Новый Структура("Использование", "ЭтоВнешняяОперация"));
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "СчетКонтрагента", "ВалютаДокумента", "Отбор.Валюта",, Новый Структура("Использование", "ЭтоВнешняяОперация"), Истина);
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "СчетКонтрагента", "ВалютаВзаиморасчетов", "Отбор.Валюта",, Новый Структура("Использование", "ЭтоВнутренняяОперация"), Истина);

	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "БанковскийСчет", "Организация", "Отбор.Владелец");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "БанковскийСчет", "ВалютаДокумента", "Отбор.Валюта",,, Истина);


	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "КроссКурс", "Дата", "Дата");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "КроссКурс", "ВалютаДокумента", "ВалютаДокумента");
	РаботаСМодельюКлиентСервер.Связь(Контекст, Модель, "КроссКурс", "ВалютаВзаиморасчетов", "ВалютаВзаиморасчетов");
	
	//  Настройка параметров состояния объекта
	Модель.Параметры["ЭтоВнутренняяОперация"].Выражение = "Параметры.ТипОперации = ПредопределенноеЗначение(""Перечисление.ТипыОперацийБюжетирование.ПеремещениеМеждуМестамиХраненияСредств"")
	| ИЛИ Параметры.ТипОперации = ПредопределенноеЗначение(""Перечисление.ТипыОперацийБюжетирование.КонвертацияВалюты"")";
	Модель.Параметры["ЭтоВнутренняяОперация"].НаСервере = Ложь;
	Модель.Параметры["ЭтоВнешняяОперация"].Выражение = "НЕ Параметры.ЭтоВнутренняяОперация";
	Модель.Параметры["ЭтоВнешняяОперация"].НаСервере = Ложь;

	Модель.Параметры["ТипОперацииБюджетирование"].Выражение = "ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ВидОперации, ""ТипОперацииБюджетирование"")";
	Модель.Параметры["ПриходРасход"].Выражение = "ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ВидОперации, ""ПриходРасход"")";
	Модель.Параметры["СуммаДокумента"].НаСервере = Ложь;
	Модель.Параметры["СуммаВзаиморасчетов"].НаСервере = Ложь;
	Модель.Параметры["СуммаВзаиморасчетов"].Выражение = "Окр(Параметры.СуммаДокумента * Параметры.КроссКурс, 2)";
	Модель.Параметры["ДвиженияОперации"].НаСервере = Ложь;
	Модель.Параметры["ДвиженияОперации"].ЭтоСсылка = Ложь;
	Модель.Параметры["ДвиженияОперации.Сумма"].НаСервере = Ложь;
	Модель.Параметры["ДвиженияОперации.СуммаВзаиморасчетов"].НаСервере = Ложь;
	Модель.Параметры["ДвиженияОперации.СуммаВзаиморасчетов"].Выражение = "Параметры.КроссКурс * Параметры.Сумма";
	Модель.Параметры["ВалютаВзаиморасчетов"].НаСервере = Истина;
	Модель.Параметры["ВалютаВзаиморасчетов"].Выражение = "ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ДоговорКонтрагента, ""Валюта"")";
	Модель.Параметры["ВалютаДокумента"].НаСервере = Ложь;
	Модель.Параметры["ДоговорКонтрагента"].ПроверкаЗаполнения = Ложь;

	Модель.Параметры["СчетКонтрагента"].ПриИзменении = "*";
	Модель.Параметры["БанковскийСчет"].ПриИзменении = "*";
	Модель.Параметры["КроссКурс"].Выражение = "*";

	//  Специальный параметр для таблицы
	Параметр = РаботаСМодельюКлиентСервер.Параметр(Контекст, Модель, "ДвиженияОперации.ИндексСтроки");
	Параметр.НаСервере = Ложь;
	Параметр.ПроверкаЗаполнения = Ложь;
	Параметр.ЭтоСсылка = Ложь;
	
	Возврат Модель;
КонецФункции