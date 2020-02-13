Функция ПолучитьТекстЗапроса(ПараметрыЗапроса = Неопределено, Параметры, Поля = "", ТекстЗапроса = Неопределено) Экспорт
	Если ПараметрыЗапроса = Неопределено Тогда
		ПараметрыЗапроса = Новый Структура;
	КонецЕсли;
	СхемаЗапроса 		= РаботаСДаннымиВыбора.ПолучитьСхемуЗапросаПоИсточнику("Справочник.ДоговорыКонтрагентов",, Поля, ТекстЗапроса);
	ЗапросИсточника		= СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество()-1];
	ОператорИсточника	= ЗапросИсточника.Операторы[0];
	Источник			= ОператорИсточника.Источники.НайтиПоПсевдониму("Источник");
	Если Параметры.Свойство("Отбор") Тогда
		ОбщийКлиентСервер.ПереместитьЗначенияСвойств(Параметры.Отбор, ПараметрыЗапроса, "Организация,Контрагент");
		Если ОбщийКлиентСервер.СтруктураСодержитСвойства(ПараметрыЗапроса, "Организация,Контрагент") Тогда
			РаботаСоСхемойЗапроса.Источник(ОператорИсточника, "Справочник.ДоговорыКонтрагентов.Стороны", "ТЧСтороны");
			РаботаСоСхемойЗапроса.Соединение(ОператорИсточника, Источник, "ТЧСтороны", "Источник.Ссылка = ТЧСтороны.Ссылка", ТипСоединенияСхемыЗапроса.Внутреннее);
			ОператорИсточника.Отбор.Добавить("ТЧСтороны.Организация = &Организация");
			ОператорИсточника.Отбор.Добавить("ТЧСтороны.Контрагент = &Контрагент");
		Иначе
			ОбщийКлиентСервер.УдалитьСвойстваСтруктуры(ПараметрыЗапроса, "Организация,Контрагент");
		КонецЕсли;
	КонецЕсли;//  Отбор
	Возврат СхемаЗапроса.ПолучитьТекстЗапроса();
КонецФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	РаботаСДаннымиВыбора.ЗаполнитьДанныеВыбора(ОбщегоНазначения.ИмяТаблицыПоСсылке(ПустаяСсылка()), ДанныеВыбора, Параметры);
КонецПроцедуры
