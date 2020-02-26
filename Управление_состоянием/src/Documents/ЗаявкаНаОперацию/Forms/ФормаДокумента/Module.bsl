#Область УправлениеСостоянием

&НаСервере
Процедура УправлениеФормойНаСервере(ИзмененныеРеквизиты = Неопределено, ЗависимыеЭлементы = Неопределено)
	РаботаСФормойКлиентСервер.УправлениеФормой(ЭтотОбъект, ИзмененныеРеквизиты, ЗависимыеЭлементы);	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой(ИзмененныеРеквизиты = Неопределено)
	Перем ЗависимыеЭлементы;
	Если НЕ РаботаСФормойКлиентСервер.УправлениеФормой(ЭтотОбъект, ИзмененныеРеквизиты, ЗависимыеЭлементы) Тогда
		УправлениеФормойНаСервере(ИзмененныеРеквизиты, ЗависимыеЭлементы);
	КонецЕсли;
КонецПроцедуры

#Область ОбработчикиСобытийФормы

//@skip-warning
&НаКлиенте
Процедура ПриАктивизацииСтроки(Элемент)
	РаботаСФормойКлиентСервер.ПриАктивизацииСтроки(ЭтотОбъект, Элемент);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	РаботаСФормойКлиентСервер.НачалоВыбора(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

#Область ПриИзменении // При расчете может потребоваться изменить контекст, а сделать это можно только в модуле формы

//@skip-warning
//  Процедура продолжает расчет уже в контексте сервера. Такое разделение процедуры нужно для программного переключения контекста
&НаСервере
Процедура РассчитатьСостояниеНаСервере(ИзмененныеРеквизиты, Состояние)
	РаботаСМодельюКлиентСервер.РассчитатьСостояние(ЭтотОбъект, ИзмененныеРеквизиты, Состояние);
	УправлениеФормойНаСервере(ИзмененныеРеквизиты);
КонецПроцедуры

//  Процедура выполняет расчет в контексте клиента
&НаКлиенте
Процедура РассчитатьСостояние(ИзмененныеРеквизиты)
	Перем Состояние;
	Если НЕ РаботаСМодельюКлиентСервер.РассчитатьСостояние(ЭтотОбъект, ИзмененныеРеквизиты, Состояние) Тогда
		РассчитатьСостояниеНаСервере(ИзмененныеРеквизиты, Состояние);
	Иначе
		УправлениеФормой(ИзмененныеРеквизиты);
	КонецЕсли;
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура ПриИзменении(Элемент)
	ОчиститьСообщения();
	Модель = РаботаСМодельюКлиентСервер.МодельОбъекта(ЭтотОбъект);
	Параметр = Модель.Параметры[Модель.ПараметрыЭлементов[Элемент.Имя]];
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Параметр.ЭтоЭлементКоллекции Тогда
		ИзмененныеРеквизиты = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РаботаСМодельюКлиентСервер.Реквизит(Параметр.Идентификатор, РаботаСМодельюКлиентСервер.ЗначениеПараметра(ЭтотОбъект, Модель, Модель.Параметры[Параметр.Коллекция + ".ИндексСтроки"])));
	Иначе
		ИзмененныеРеквизиты = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РаботаСМодельюКлиентСервер.Реквизит(Параметр.Идентификатор));
	КонецЕсли;
	РассчитатьСостояние(ИзмененныеРеквизиты);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//  Инициализация модели объекта
	Модель = Документы.ЗаявкаНаОперацию.Модель(ЭтотОбъект);
	//  Настройка элементов формы и их зависимостей: Элемент формы <- Параметры состояния
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель,, "ТолькоПросмотр,Номер,ПриходРасход,СуммаДокумента,ВалютаДокумента,ДатаНачала,Контрагент,ВидОперацииБюджетирование,ПометкаУдаления,Проведен,ЭтоНовый");
	
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.ФормаОплаты, "ТипОперацииБюджетирование");
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.СчетКонтрагента, "ФормаОплаты");
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.КонтрагентРасчетов, "РасчетыЧерезТретьихЛиц");
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.ДоговорРасчетов, "РасчетыЧерезТретьихЛиц");
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.ГруппаРасчетыЧерезТретьихЛиц, "РасчетыЧерезТретьихЛиц");
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.СуммаВзаиморасчетов, "ВалютаВзаиморасчетов,ВалютаДокумента");
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.ВалютаВзаиморасчетов, "ВалютаВзаиморасчетов,ВалютаДокумента,ДоговорКонтрагента");
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.СтраницаАналитикиБюджетирования, "ДвиженияОперации");
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.ДвиженияОперацииСуммаВзаиморасчетов, "ВалютаВзаиморасчетов,ВалютаДокумента");
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.ДвиженияОперацииСумма, "ВалютаДокумента");
	
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.ГруппаРеквизитыКонтрагента, "ТипОперацииБюджетирование");
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.ГруппаКонвертацияРасчетов, "ТипОперацииБюджетирование");
	
	РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.Страницы, "ТипОперацииБюджетирование");
	
	//  Настройка связанных по значению параметров Комментарий <- _Комментарий
	РаботаСМодельюКлиентСервер.Связь(ЭтотОбъект, Модель, "Комментарий", "_Комментарий", "Комментарий");
	Модель.Параметры["_Комментарий"].НаСервере = Ложь;
	Модель.Параметры["_Комментарий"].Выражение = "Объект.Комментарий";
	Модель.Параметры["Комментарий"].НаСервере = Ложь;
	Модель.Параметры["Комментарий"].Выражение = "Параметры.Комментарий";

	РаботаСМодельюКлиентСервер.Связь(ЭтотОбъект, Модель, "ЭтоНовый", "Ссылка", "Ссылка");
	Модель.Параметры["Ссылка"].НаСервере = Ложь;
	Модель.Параметры["Ссылка"].ПроверкаЗаполнения = Ложь;
	Модель.Параметры["ЭтоНовый"].НаСервере = Ложь;
	Модель.Параметры["ЭтоНовый"].Выражение = "НЕ ЗначениеЗаполнено(Объект.Ссылка)";

	//  Связывание модели и формы. Первоначальный расчет параметров
	РаботаСФормой.УстановитьСвязьСЭлементамиФормы(ЭтотОбъект, Модель, Элементы);
	
	//  Подготовка и размещение модели в хранилище значений параметров состояния
	РаботаСМодельюКлиентСервер.ОпределитьПорядок(Модель);
	РаботаСМоделью.СоздатьХранилищеЗначений(ЭтотОбъект, Модель);
	РаботаСМоделью.РассчитатьПроизводныеПараметры(ЭтотОбъект);
	
	УправлениеФормойНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭтаФорма, "ХранилищеЗначений") Тогда
		УправлениеФормойНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УправлениеФормойНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаИзменитьДанныеОбъекта(Команда)
	ОчиститьСообщения();
	КомандаИзменитьДанныеОбъектаНаСервере();
КонецПроцедуры

&НаСервере
Процедура КомандаИзменитьДанныеОбъектаНаСервере()
	Перем ИзмененныеРеквизиты;

	//  Работа с объектом через программный интерфейс
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	РаботаСМоделью.Инициализировать(ДокументОбъект);
	РаботаСМодельюКлиентСервер.УстановитьЗначение(ДокументОбъект, "Дата", , '20200218', ИзмененныеРеквизиты);
	РаботаСМодельюКлиентСервер.УстановитьЗначение(ДокументОбъект, "ВалютаДокумента", , Справочники.Валюты.НайтиПоНаименованию("USD"), ИзмененныеРеквизиты);
	РаботаСМодельюКлиентСервер.РассчитатьСостояние(ДокументОбъект, ИзмененныеРеквизиты);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");

	//  Обновление параметров модели формы
	РаботаСМоделью.РассчитатьПроизводныеПараметры(ЭтотОбъект);
	Модифицированность = Истина;
	УправлениеФормойНаСервере();
КонецПроцедуры


#КонецОбласти
