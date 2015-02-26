/*
 * Copyright (C) 2015 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "statictimezonemodel.h"

StaticTimeZoneModel::StaticTimeZoneModel(QObject *parent) :
    TimeZoneModel(parent)
{
    // Load default city list into model when object is initiated
    loadDefaultCityList();
}

void StaticTimeZoneModel::loadDefaultCityList()
{
    // Let QML know model is being reset and rebuilt
    beginResetModel();

    m_timeZones.clear();

    TimeZone tz;

    tz.cityName = tr("Abidjan");
    tz.country = tr("Africa/Abidjan");
    tz.timeZone = QTimeZone("Europe/Amsterdam");
    m_timeZones.append(tz);

    tz.cityName = tr("Accra");
    tz.country = tr("Ghana");
    tz.timeZone = QTimeZone("Africa/Accra");
    m_timeZones.append(tz);

    tz.cityName = tr("Addis Ababa");
    tz.timeZone = QTimeZone("Africa/Addis_Ababa");
    tz.country = tr("Ethiopia");
    m_timeZones.append(tz);

    tz.cityName = tr("Adelaide");
    tz.timeZone = QTimeZone("Australia/Adelaide");
    tz.country = tr("Australia");
    m_timeZones.append(tz);

    tz.cityName = tr("Albuquerque");
    tz.timeZone = QTimeZone("America/Denver");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Algiers");
    tz.timeZone = QTimeZone("Africa/Algiers");
    tz.country = tr("Algeria");
    m_timeZones.append(tz);

    tz.cityName = tr("Almaty");
    tz.timeZone = QTimeZone("Asia/Almaty");
    tz.country = tr("Kazakhstan");
    m_timeZones.append(tz);

    tz.cityName = tr("Amman");
    tz.timeZone = QTimeZone("Asia/Amman");
    tz.country = tr("Jordan");
    m_timeZones.append(tz);

    tz.cityName = tr("Amsterdam");
    tz.timeZone = QTimeZone("Europe/Amsterdam");
    tz.country = tr("Netherlands");
    m_timeZones.append(tz);

    tz.cityName = tr("Anadyr");
    tz.timeZone = QTimeZone("Asia/Anadyr");
    tz.country = tr("Russia");
    m_timeZones.append(tz);

    tz.cityName = tr("Anchorage");
    tz.timeZone = QTimeZone("America/Anchorage");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Andorra");
    tz.timeZone = QTimeZone("Europe/Andorra");
    tz.country = tr("Andorra");
    m_timeZones.append(tz);

    tz.cityName = tr("Ankara");
    tz.timeZone = QTimeZone("Europe/Istanbul");
    tz.country = tr("Turkey");
    m_timeZones.append(tz);

    tz.cityName = tr("Ann Arbor");
    tz.timeZone = QTimeZone("America/Detroit");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Antananarivo");
    tz.timeZone = QTimeZone("Indian/Antananarivo");
    tz.country = tr("Madagascar");
    m_timeZones.append(tz);

    tz.cityName = tr("Aqtau");
    tz.timeZone = QTimeZone("Asia/Aqtau");
    tz.country = tr("Kazakhstan");
    m_timeZones.append(tz);

    tz.cityName = tr("Aruba");
    tz.timeZone = QTimeZone("America/Aruba");
    tz.country = tr("Aruba");
    m_timeZones.append(tz);

    tz.cityName = tr("Asunción");
    tz.timeZone = QTimeZone("America/Asuncion");
    tz.country = tr("Paraguay");
    m_timeZones.append(tz);

    tz.cityName = tr("Athens");
    tz.timeZone = QTimeZone("Europe/Athens");
    tz.country = tr("Greece");
    m_timeZones.append(tz);

    tz.cityName = tr("Atlanta");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Auckland");
    tz.timeZone = QTimeZone("Pacific/Auckland");
    tz.country = tr("New Zealand");
    m_timeZones.append(tz);

    tz.cityName = tr("Austin");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Baghdad");
    tz.timeZone = QTimeZone("Asia/Baghdad");
    tz.country = tr("Iraq");
    m_timeZones.append(tz);

    tz.cityName = tr("Bahrain");
    tz.timeZone = QTimeZone("Asia/Bahrain");
    tz.country = tr("Bahrain");
    m_timeZones.append(tz);

    tz.cityName = tr("Baku");
    tz.timeZone = QTimeZone("Asia/Baku");
    tz.country = tr("Azerbaijan");
    m_timeZones.append(tz);

    tz.cityName = tr("Baltimore");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Bangalore");
    tz.timeZone = QTimeZone("Asia/Kolkata");
    tz.country = tr("India");
    m_timeZones.append(tz);

    tz.cityName = tr("Bangkok");
    tz.timeZone = QTimeZone("Asia/Bangkok");
    tz.country = tr("Thailand");
    m_timeZones.append(tz);

    tz.cityName = tr("Barbados");
    tz.timeZone = QTimeZone("America/Barbados");
    tz.country = tr("Barbados");
    m_timeZones.append(tz);

    tz.cityName = tr("Barcelona");
    tz.timeZone = QTimeZone("Europe/Madrid");
    tz.country = tr("Spain");
    m_timeZones.append(tz);

    tz.cityName = tr("Beijing");
    tz.timeZone = QTimeZone("Asia/Shanghai");
    tz.country = tr("China");
    m_timeZones.append(tz);

    tz.cityName = tr("Beirut");
    tz.timeZone = QTimeZone("Asia/Beirut");
    tz.country = tr("Lebanon");
    m_timeZones.append(tz);

    tz.cityName = tr("Belfast");
    tz.timeZone = QTimeZone("Europe/Belfast");
    tz.country = tr("United Kingdom");
    m_timeZones.append(tz);

    tz.cityName = tr("Belgrade");
    tz.timeZone = QTimeZone("Europe/Belgrade");
    tz.country = tr("Serbia");
    m_timeZones.append(tz);

    tz.cityName = tr("Belize");
    tz.timeZone = QTimeZone("America/Belize");
    tz.country = tr("Belize");
    m_timeZones.append(tz);

    tz.cityName = tr("Belo Horizonte");
    tz.timeZone = QTimeZone("America/Sao_Paulo");
    tz.country = tr("Brazil");
    m_timeZones.append(tz);

    tz.cityName = tr("Berlin");
    tz.timeZone = QTimeZone("Europe/Berlin");
    tz.country = tr("Germany");
    m_timeZones.append(tz);

    tz.cityName = tr("Bermuda");
    tz.timeZone = QTimeZone("Atlantic/Bermuda");
    tz.country = tr("Bermuda");
    m_timeZones.append(tz);

    tz.cityName = tr("Beulah");
    tz.timeZone = QTimeZone("America/North_Dakota/Beulah");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Black Rock City");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Blantyre");
    tz.timeZone = QTimeZone("Africa/Blantyre");
    tz.country = tr("Malawi");
    m_timeZones.append(tz);

    tz.cityName = tr("Bogotá");
    tz.timeZone = QTimeZone("America/Bogota");
    tz.country = tr("Colombia");
    m_timeZones.append(tz);

    tz.cityName = tr("Boston");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Boulder");
    tz.timeZone = QTimeZone("America/Denver");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Brasília");
    tz.timeZone = QTimeZone("America/Sao_Paulo");
    tz.country = tr("Brazil");
    m_timeZones.append(tz);

    tz.cityName = tr("Bratislava");
    tz.timeZone = QTimeZone("Europe/Bratislava");
    tz.country = tr("Slovakia");
    m_timeZones.append(tz);

    tz.cityName = tr("Brazzaville");
    tz.timeZone = QTimeZone("Africa/Brazzaville");
    tz.country = tr("Republic of the Congo");
    m_timeZones.append(tz);

    tz.cityName = tr("Brisbane");
    tz.timeZone = QTimeZone("Australia/Brisbane");
    tz.country = tr("Australia");
    m_timeZones.append(tz);

    tz.cityName = tr("Brussels");
    tz.timeZone = QTimeZone("Europe/Brussels");
    tz.country = tr("Belgium");
    m_timeZones.append(tz);

    tz.cityName = tr("Bucharest");
    tz.timeZone = QTimeZone("Europe/Bucharest");
    tz.country = tr("Romania");
    m_timeZones.append(tz);

    tz.cityName = tr("Budapest");
    tz.timeZone = QTimeZone("Europe/Budapest");
    tz.country = tr("Hungary");
    m_timeZones.append(tz);

    tz.cityName = tr("Buenos Aires");
    tz.timeZone = QTimeZone("America/Argentina/Buenos_Aires");
    tz.country = tr("Argentina");
    m_timeZones.append(tz);

    tz.cityName = tr("Cairo");
    tz.timeZone = QTimeZone("Africa/Cairo");
    tz.country = tr("Egypt");
    m_timeZones.append(tz);

    tz.cityName = tr("Calcutta");
    tz.timeZone = QTimeZone("Asia/Calcutta");
    tz.country = tr("India");
    m_timeZones.append(tz);

    tz.cityName = tr("Calgary");
    tz.timeZone = QTimeZone("America/Edmonton");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Cambridge");
    tz.timeZone = QTimeZone("Europe/London");
    tz.country = tr("United Kingdom");
    m_timeZones.append(tz);

    tz.cityName = tr("Canary");
    tz.timeZone = QTimeZone("Atlantic/Canary");
    tz.country = tr("Australia");
    m_timeZones.append(tz);

    tz.cityName = tr("Canberra");
    tz.timeZone = QTimeZone("Australia/Canberra");
    tz.country = tr("Australia");
    m_timeZones.append(tz);

    tz.cityName = tr("Cancún");
    tz.timeZone = QTimeZone("America/Cancun");
    tz.country = tr("Mexico");
    m_timeZones.append(tz);

    tz.cityName = tr("Cape Town");
    tz.timeZone = QTimeZone("Africa/Johannesburg");
    tz.country = tr("South Africa");
    m_timeZones.append(tz);

    tz.cityName = tr("Caracas");
    tz.timeZone = QTimeZone("America/Caracas");
    tz.country = tr("Venezuela");
    m_timeZones.append(tz);

    tz.cityName = tr("Casablanca");
    tz.timeZone = QTimeZone("Africa/Casablanca");
    tz.country = tr("Morocco");
    m_timeZones.append(tz);

    tz.cityName = tr("Cayman Palms");
    tz.timeZone = QTimeZone("America/Cayman");
    tz.country = tr("Cayman Islands");
    m_timeZones.append(tz);

    tz.cityName = tr("Chicago");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Chihuahua");
    tz.timeZone = QTimeZone("America/Chihuahua");
    tz.country = tr("Mexico");
    m_timeZones.append(tz);

    tz.cityName = tr("Chişinău");
    tz.timeZone = QTimeZone("Europe/Chisinau");
    tz.country = tr("Moldova");
    m_timeZones.append(tz);

    tz.cityName = tr("Cincinnati");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Cleveland");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Colombo");
    tz.timeZone = QTimeZone("Asia/Colombo");
    tz.country = tr("Sri Lanka");
    m_timeZones.append(tz);

    tz.cityName = tr("Columbus");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Conakry");
    tz.timeZone = QTimeZone("Africa/Conakry");
    tz.country = tr("Guinea");
    m_timeZones.append(tz);

    tz.cityName = tr("Copenhagen");
    tz.timeZone = QTimeZone("Europe/Copenhagen");
    tz.country = tr("Denmark");
    m_timeZones.append(tz);

    tz.cityName = tr("Costa Rica");
    tz.timeZone = QTimeZone("America/Costa_Rica");
    tz.country = tr("Costa Rica");
    m_timeZones.append(tz);

    tz.cityName = tr("Curaçao");
    tz.timeZone = QTimeZone("America/Curacao");
    tz.country = tr("Curacao");
    m_timeZones.append(tz);

    tz.cityName = tr("Dakar");
    tz.timeZone = QTimeZone("Africa/Dakar");
    tz.country = tr("Senegal");
    m_timeZones.append(tz);

    tz.cityName = tr("Dallas");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Damascus");
    tz.timeZone = QTimeZone("Asia/Damascus");
    tz.country = tr("Syria");
    m_timeZones.append(tz);

    tz.cityName = tr("Dar es Salaam");
    tz.timeZone = QTimeZone("Africa/Dar_es_Salaam");
    tz.country = tr("Tanzania");
    m_timeZones.append(tz);

    tz.cityName = tr("Darwin");
    tz.timeZone = QTimeZone("Australia/Darwin");
    tz.country = tr("Australia");
    m_timeZones.append(tz);

    tz.cityName = tr("Dawson Creek");
    tz.timeZone = QTimeZone("America/Dawson_Creek");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Delhi");
    tz.timeZone = QTimeZone("Asia/Kolkata");
    tz.country = tr("India");
    m_timeZones.append(tz);

    tz.cityName = tr("Denver");
    tz.timeZone = QTimeZone("America/Denver");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Detroit");
    tz.timeZone = QTimeZone("America/Detroit");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Dhaka");
    tz.timeZone = QTimeZone("Asia/Dhaka");
    tz.country = tr("Bangladesh");
    m_timeZones.append(tz);

    tz.cityName = tr("Djibouti");
    tz.timeZone = QTimeZone("Africa/Djibouti");
    tz.country = tr("Djibouti");
    m_timeZones.append(tz);

    tz.cityName = tr("Doha");
    tz.timeZone = QTimeZone("Asia/Qatar");
    tz.country = tr("Qatar");
    m_timeZones.append(tz);

    tz.cityName = tr("Dominica");
    tz.timeZone = QTimeZone("America/Dominica");
    tz.country = tr("Dominica");
    m_timeZones.append(tz);

    tz.cityName = tr("Dubai");
    tz.timeZone = QTimeZone("Asia/Dubai");
    tz.country = tr("United Arab Emirates");
    m_timeZones.append(tz);

    tz.cityName = tr("Dublin");
    tz.timeZone = QTimeZone("Europe/Dublin");
    tz.country = tr("Ireland");
    m_timeZones.append(tz);

    tz.cityName = tr("Easter Island");
    tz.timeZone = QTimeZone("Pacific/Easter");
    tz.country = tr("Chile");
    m_timeZones.append(tz);

    tz.cityName = tr("Edmonton");
    tz.timeZone = QTimeZone("America/Edmonton");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("El Salvador");
    tz.timeZone = QTimeZone("America/El_Salvador");
    tz.country = tr("El Salvador");
    m_timeZones.append(tz);

    tz.cityName = tr("Fiji");
    tz.timeZone = QTimeZone("Pacific/Fiji");
    tz.country = tr("Fiji");
    m_timeZones.append(tz);

    tz.cityName = tr("Fortaleza");
    tz.timeZone = QTimeZone("America/Fortaleza");
    tz.country = tr("Brazil");
    m_timeZones.append(tz);

    tz.cityName = tr("Frankfurt");
    tz.timeZone = QTimeZone("Europe/Berlin");
    tz.country = tr("Germany");
    m_timeZones.append(tz);

    tz.cityName = tr("Freetown");
    tz.timeZone = QTimeZone("Africa/Freetown");
    tz.country = tr("Sierra Leone");
    m_timeZones.append(tz);

    tz.cityName = tr("Gaborone");
    tz.timeZone = QTimeZone("Africa/Gaborone");
    tz.country = tr("Botswana");
    m_timeZones.append(tz);

    tz.cityName = tr("Gaza");
    tz.timeZone = QTimeZone("Asia/Gaza");
    tz.country = tr("Palestine");
    m_timeZones.append(tz);

    tz.cityName = tr("Gibraltar");
    tz.timeZone = QTimeZone("Europe/Gibraltar");
    tz.country = tr("Gibraltar");
    m_timeZones.append(tz);

    tz.cityName = tr("Grand Turk");
    tz.timeZone = QTimeZone("America/Grand_Turk");
    tz.country = tr("Turks and Caicos Islands");
    m_timeZones.append(tz);

    tz.cityName = tr("Grenada");
    tz.timeZone = QTimeZone("America/Grenada");
    tz.country = tr("Grenada");
    m_timeZones.append(tz);

    tz.cityName = tr("Guam");
    tz.timeZone = QTimeZone("Pacific/Guam");
    tz.country = tr("Guam");
    m_timeZones.append(tz);

    tz.cityName = tr("Guangzhou");
    tz.timeZone = QTimeZone("Asia/Shanghai");
    tz.country = tr("China");
    m_timeZones.append(tz);

    tz.cityName = tr("Guatemala");
    tz.timeZone = QTimeZone("America/Guatemala");
    tz.country = tr("Guatemala");
    m_timeZones.append(tz);

    tz.cityName = tr("Gurgaon");
    tz.timeZone = QTimeZone("Asia/Kolkata");
    tz.country = tr("India");
    m_timeZones.append(tz);

    tz.cityName = tr("Guyana");
    tz.timeZone = QTimeZone("America/Guyana");
    tz.country = tr("Guyana");
    m_timeZones.append(tz);

    tz.cityName = tr("Haifa");
    tz.timeZone = QTimeZone("Asia/Jerusalem");
    tz.country = tr("Israel");
    m_timeZones.append(tz);

    tz.cityName = tr("Halifax");
    tz.timeZone = QTimeZone("America/Halifax");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Hamburg");
    tz.timeZone = QTimeZone("Europe/Berlin");
    tz.country = tr("Germany");
    m_timeZones.append(tz);

    tz.cityName = tr("Hanoi");
    tz.timeZone = QTimeZone("Asia/Ho_Chi_Minh");
    tz.country = tr("Vietnam");
    m_timeZones.append(tz);

    tz.cityName = tr("Harare");
    tz.timeZone = QTimeZone("Africa/Harare");
    tz.country = tr("Zimbabwe");
    m_timeZones.append(tz);

    tz.cityName = tr("Havana");
    tz.timeZone = QTimeZone("America/Havana");
    tz.country = tr("Cuba");
    m_timeZones.append(tz);

    tz.cityName = tr("Hebron");
    tz.timeZone = QTimeZone("Asia/Hebron");
    tz.country = tr("Palestine");
    m_timeZones.append(tz);

    tz.cityName = tr("Helsinki");
    tz.timeZone = QTimeZone("Europe/Helsinki");
    tz.country = tr("Finland");
    m_timeZones.append(tz);

    tz.cityName = tr("Ho Chi Minh City");
    tz.timeZone = QTimeZone("Asia/Ho_Chi_Minh");
    tz.country = tr("Vietnam");
    m_timeZones.append(tz);

    tz.cityName = tr("Hong Kong");
    tz.timeZone = QTimeZone("Asia/Hong_Kong");
    tz.country = tr("Hong Kong");
    m_timeZones.append(tz);

    tz.cityName = tr("Honolulu");
    tz.timeZone = QTimeZone("Pacific/Honolulu");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Houston");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Hyderabad");
    tz.timeZone = QTimeZone("Asia/Kolkata");
    tz.country = tr("India");
    m_timeZones.append(tz);

    tz.cityName = tr("Indianapolis");
    tz.timeZone = QTimeZone("America/Indiana/Indianapolis");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Islamabad");
    tz.timeZone = QTimeZone("Asia/Karachi");
    tz.country = tr("Pakistan");
    m_timeZones.append(tz);

    tz.cityName = tr("Isle of Man");
    tz.timeZone = QTimeZone("Europe/Isle_of_Man");
    tz.country = tr("Isle of Man");
    m_timeZones.append(tz);

    tz.cityName = tr("Istanbul");
    tz.timeZone = QTimeZone("Europe/Istanbul");
    tz.country = tr("Turkey");
    m_timeZones.append(tz);

    tz.cityName = tr("Jacksonville");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Jakarta");
    tz.timeZone = QTimeZone("Asia/Jakarta");
    tz.country = tr("Indonesia");
    m_timeZones.append(tz);

    tz.cityName = tr("Jerusalem");
    tz.timeZone = QTimeZone("Asia/Jerusalem");
    tz.country = tr("Israel");
    m_timeZones.append(tz);

    tz.cityName = tr("Johannesburg");
    tz.timeZone = QTimeZone("Africa/Johannesburg");
    tz.country = tr("South Africa");
    m_timeZones.append(tz);

    tz.cityName = tr("Kabul");
    tz.timeZone = QTimeZone("Asia/Kabul");
    tz.country = tr("Afghanistan");
    m_timeZones.append(tz);

    tz.cityName = tr("Kampala");
    tz.timeZone = QTimeZone("Africa/Kampala");
    tz.country = tr("Uganda");
    m_timeZones.append(tz);

    tz.cityName = tr("Karachi");
    tz.timeZone = QTimeZone("Asia/Karachi");
    tz.country = tr("Pakistan");
    m_timeZones.append(tz);

    tz.cityName = tr("Khartoum");
    tz.timeZone = QTimeZone("Africa/Khartoum");
    tz.country = tr("Sudan");
    m_timeZones.append(tz);

    tz.cityName = tr("Kiev");
    tz.timeZone = QTimeZone("Europe/Kiev");
    tz.country = tr("Ukraine");
    m_timeZones.append(tz);

    tz.cityName = tr("Kigali");
    tz.timeZone = QTimeZone("Africa/Kigali");
    tz.country = tr("Rwanda");
    m_timeZones.append(tz);

    tz.cityName = tr("Kingston");
    tz.timeZone = QTimeZone("America/Toronto");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Kinshasa");
    tz.timeZone = QTimeZone("Africa/Kinshasa");
    tz.country = tr("Democratic Republic of the Congo");
    m_timeZones.append(tz);

    tz.cityName = tr("Kiritimati");
    tz.timeZone = QTimeZone("Pacific/Kiritimati");
    tz.country = tr("Kiribati");
    m_timeZones.append(tz);

    tz.cityName = tr("Kirkland");
    tz.timeZone = QTimeZone("America/Montreal");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Knox");
    tz.timeZone = QTimeZone("Australia/Melbourne");
    tz.country = tr("Australia");
    m_timeZones.append(tz);

    tz.cityName = tr("Knoxville");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Kraków");
    tz.timeZone = QTimeZone("Europe/Warsaw");
    tz.country = tr("Poland");
    m_timeZones.append(tz);

    tz.cityName = tr("Kuala Lumpur");
    tz.timeZone = QTimeZone("Asia/Kuala_Lumpur");
    tz.country = tr("Malaysia");
    m_timeZones.append(tz);

    tz.cityName = tr("Kuwait City");
    tz.timeZone = QTimeZone("Asia/Kuwait");
    tz.country = tr("Kuwait");
    m_timeZones.append(tz);

    tz.cityName = tr("Kyiv");
    tz.timeZone = QTimeZone("Europe/Kiev");
    tz.country = tr("Ukraine");
    m_timeZones.append(tz);

    tz.cityName = tr("Lagos");
    tz.timeZone = QTimeZone("Africa/Lagos");
    tz.country = tr("Nigeria");
    m_timeZones.append(tz);

    tz.cityName = tr("Lahore");
    tz.timeZone = QTimeZone("Asia/Karachi");
    tz.country = tr("Pakistan");
    m_timeZones.append(tz);

    tz.cityName = tr("Las Vegas");
    tz.timeZone = QTimeZone("America/Los_Angeles");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Lima");
    tz.timeZone = QTimeZone("America/Lima");
    tz.country = tr("Peru");
    m_timeZones.append(tz);

    tz.cityName = tr("Lisbon");
    tz.timeZone = QTimeZone("Europe/Lisbon");
    tz.country = tr("Portugal");
    m_timeZones.append(tz);

    tz.cityName = tr("London");
    tz.timeZone = QTimeZone("Europe/London");
    tz.country = tr("United Kingdom");
    m_timeZones.append(tz);

    tz.cityName = tr("Longyearbyen");
    tz.timeZone = QTimeZone("Arctic/Longyearbyen");
    tz.country = tr("Svalbard and Jan Mayen");
    m_timeZones.append(tz);

    tz.cityName = tr("Los Angeles");
    tz.timeZone = QTimeZone("America/Los_Angeles");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Louisville");
    tz.timeZone = QTimeZone("America/Kentucky/Louisville");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Luxembourg");
    tz.timeZone = QTimeZone("Europe/Luxembourg");
    tz.country = tr("Luxembourg");
    m_timeZones.append(tz);

    tz.cityName = tr("Macau");
    tz.timeZone = QTimeZone("Asia/Macau");
    tz.country = tr("Macao");
    m_timeZones.append(tz);

    tz.cityName = tr("Madison");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Madrid");
    tz.timeZone = QTimeZone("Europe/Madrid");
    tz.country = tr("Spain");
    m_timeZones.append(tz);

    tz.cityName = tr("Maldives");
    tz.timeZone = QTimeZone("Indian/Maldives");
    tz.country = tr("Maldives");
    m_timeZones.append(tz);

    tz.cityName = tr("Malta");
    tz.timeZone = QTimeZone("Europe/Malta");
    tz.country = tr("Malta");
    m_timeZones.append(tz);

    tz.cityName = tr("Managua");
    tz.timeZone = QTimeZone("America/Managua");
    tz.country = tr("Nicaragua");
    m_timeZones.append(tz);

    tz.cityName = tr("Manchester");
    tz.timeZone = QTimeZone("Europe/London");
    tz.country = tr("United Kingdom");
    m_timeZones.append(tz);

    tz.cityName = tr("Manila");
    tz.timeZone = QTimeZone("Asia/Manila");
    tz.country = tr("Philippines");
    m_timeZones.append(tz);

    tz.cityName = tr("Marengo");
    tz.timeZone = QTimeZone("America/Indiana/Marengo");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Martinique");
    tz.timeZone = QTimeZone("America/Martinique");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Maseru");
    tz.timeZone = QTimeZone("Africa/Maseru");
    tz.country = tr("Lesotho");
    m_timeZones.append(tz);

    tz.cityName = tr("Melbourne");
    tz.timeZone = QTimeZone("Australia/Melbourne");
    tz.country = tr("Australia");
    m_timeZones.append(tz);

    tz.cityName = tr("Memphis");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Mendoza");
    tz.timeZone = QTimeZone("America/Argentina/Mendoza");
    tz.country = tr("Argentina");
    m_timeZones.append(tz);

    tz.cityName = tr("Metlakatla");
    tz.timeZone = QTimeZone("America/Metlakatla");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Mexico City");
    tz.timeZone = QTimeZone("America/Mexico_City");
    tz.country = tr("Mexico");
    m_timeZones.append(tz);

    tz.cityName = tr("Miami");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Milan");
    tz.timeZone = QTimeZone("Europe/Rome");
    tz.country = tr("Italy");
    m_timeZones.append(tz);

    tz.cityName = tr("Milwaukee");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Minneapolis");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Minsk");
    tz.timeZone = QTimeZone("Europe/Minsk");
    tz.country = tr("Belarus");
    m_timeZones.append(tz);

    tz.cityName = tr("Mogadishu");
    tz.timeZone = QTimeZone("Africa/Mogadishu");
    tz.country = tr("Somalia");
    m_timeZones.append(tz);

    tz.cityName = tr("Monrovia");
    tz.timeZone = QTimeZone("Africa/Monrovia");
    tz.country = tr("Liberia");
    m_timeZones.append(tz);

    tz.cityName = tr("Monaco");
    tz.timeZone = QTimeZone("Europe/Monaco");
    tz.country = tr("Monaco");
    m_timeZones.append(tz);

    tz.cityName = tr("Monterrey");
    tz.timeZone = QTimeZone("America/Monterrey");
    tz.country = tr("Mexico");
    m_timeZones.append(tz);

    tz.cityName = tr("Montevideo");
    tz.timeZone = QTimeZone("America/Montevideo");
    tz.country = tr("Uruguay");
    m_timeZones.append(tz);

    tz.cityName = tr("Montreal");
    tz.timeZone = QTimeZone("America/Montreal");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Moscow");
    tz.timeZone = QTimeZone("Europe/Moscow");
    tz.country = tr("Russia");
    m_timeZones.append(tz);

    tz.cityName = tr("Mountain View");
    tz.timeZone = QTimeZone("America/Los_Angeles");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Mumbai");
    tz.timeZone = QTimeZone("Asia/Kolkata");
    tz.country = tr("India");
    m_timeZones.append(tz);

    tz.cityName = tr("Munich");
    tz.timeZone = QTimeZone("Europe/Berlin");
    tz.country = tr("Germany");
    m_timeZones.append(tz);

    tz.cityName = tr("Muscat");
    tz.timeZone = QTimeZone("Asia/Muscat");
    tz.country = tr("Oman");
    m_timeZones.append(tz);

    tz.cityName = tr("Nairobi");
    tz.timeZone = QTimeZone("Africa/Nairobi");
    tz.country = tr("Kenya");
    m_timeZones.append(tz);

    tz.cityName = tr("Nashville");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Nassau");
    tz.timeZone = QTimeZone("America/Nassau");
    tz.country = tr("Bahamas");
    m_timeZones.append(tz);

    tz.cityName = tr("New Orleans");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("New Salem");
    tz.timeZone = QTimeZone("America/North_Dakota/New_Salem");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("New South Wales");
    tz.timeZone = QTimeZone("Australia/Sydney");
    tz.country = tr("Australia");
    m_timeZones.append(tz);

    tz.cityName = tr("New York");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Newfoundland");
    tz.timeZone = QTimeZone("America/St_Johns");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Nouméa");
    tz.timeZone = QTimeZone("Pacific/Noumea");
    tz.country = tr("New Caledonia");
    m_timeZones.append(tz);

    tz.cityName = tr("Nuestra Señora de La Paz");
    tz.timeZone = QTimeZone("America/Bogota");
    tz.country = tr("Colombia");
    m_timeZones.append(tz);

    tz.cityName = tr("Oklahoma City");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Osaka");
    tz.timeZone = QTimeZone("Asia/Tokyo");
    tz.country = tr("Japan");
    m_timeZones.append(tz);

    tz.cityName = tr("Oslo");
    tz.timeZone = QTimeZone("Europe/Oslo");
    tz.country = tr("Norway");
    m_timeZones.append(tz);

    tz.cityName = tr("Ottawa");
    tz.timeZone = QTimeZone("America/Toronto");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Oulu");
    tz.timeZone = QTimeZone("Europe/Helsinki");
    tz.country = tr("Finland");
    m_timeZones.append(tz);

    tz.cityName = tr("Panamá");
    tz.timeZone = QTimeZone("America/Panama");
    tz.country = tr("Panama");
    m_timeZones.append(tz);

    tz.cityName = tr("Paramaribo");
    tz.timeZone = QTimeZone("America/Paramaribo");
    tz.country = tr("Suriname");
    m_timeZones.append(tz);

    tz.cityName = tr("Paris");
    tz.timeZone = QTimeZone("Europe/Paris");
    tz.country = tr("France");
    m_timeZones.append(tz);

    tz.cityName = tr("Perth");
    tz.timeZone = QTimeZone("Australia/Perth");
    tz.country = tr("Australia");
    m_timeZones.append(tz);

    tz.cityName = tr("Petersburg");
    tz.timeZone = QTimeZone("America/Indiana/Petersburg");
    tz.country = tr("Russia");
    m_timeZones.append(tz);

    tz.cityName = tr("Philadelphia");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Phnom Penh");
    tz.timeZone = QTimeZone("Asia/Phnom_Penh");
    tz.country = tr("Cambodia");
    m_timeZones.append(tz);

    tz.cityName = tr("Phoenix");
    tz.timeZone = QTimeZone("America/Phoenix");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Pittsburgh");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Port of Spain");
    tz.timeZone = QTimeZone("America/Port_of_Spain");
    tz.country = tr("Trinidad and Tobago");
    m_timeZones.append(tz);

    tz.cityName = tr("Port au Prince");
    tz.timeZone = QTimeZone("America/Port-au-Prince");
    tz.country = tr("Haiti");
    m_timeZones.append(tz);

    tz.cityName = tr("Portland");
    tz.timeZone = QTimeZone("America/Los_Angeles");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Prague");
    tz.timeZone = QTimeZone("Europe/Prague");
    tz.country = tr("Czech");
    m_timeZones.append(tz);

    tz.cityName = tr("Pyongyang");
    tz.timeZone = QTimeZone("Asia/Pyongyang");
    tz.country = tr("North Korea");
    m_timeZones.append(tz);

    tz.cityName = tr("Queensland");
    tz.timeZone = QTimeZone("Australia/Brisbane");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Quito");
    tz.timeZone = QTimeZone("America/Guayaquil");
    tz.country = tr("Ecuador");
    m_timeZones.append(tz);

    tz.cityName = tr("Rangoon");
    tz.timeZone = QTimeZone("Asia/Rangoon");
    tz.country = tr("Myanmar");
    m_timeZones.append(tz);

    tz.cityName = tr("Reno");
    tz.timeZone = QTimeZone("America/Los_Angeles");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Reston");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Reykjavík");
    tz.timeZone = QTimeZone("Atlantic/Reykjavik");
    tz.country = tr("Iceland");
    m_timeZones.append(tz);

    tz.cityName = tr("Riga");
    tz.timeZone = QTimeZone("Europe/Riga");
    tz.country = tr("Latvia");
    m_timeZones.append(tz);

    tz.cityName = tr("Rio de Janeiro");
    tz.timeZone = QTimeZone("America/Sao_Paulo");
    tz.country = tr("Brazil");
    m_timeZones.append(tz);

    tz.cityName = tr("Riyadh");
    tz.timeZone = QTimeZone("Asia/Riyadh");
    tz.country = tr("Saudi Arabia");
    m_timeZones.append(tz);

    tz.cityName = tr("Rome");
    tz.timeZone = QTimeZone("Europe/Rome");
    tz.country = tr("Italy");
    m_timeZones.append(tz);

    tz.cityName = tr("Sacramento");
    tz.timeZone = QTimeZone("America/Los_Angeles");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Salt Lake City");
    tz.timeZone = QTimeZone("America/Denver");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Samoa");
    tz.timeZone = QTimeZone("Pacific/Apia");
    tz.country = tr("Samoa");
    m_timeZones.append(tz);

    tz.cityName = tr("San Antonio");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("San Diego");
    tz.timeZone = QTimeZone("America/Los_Angeles");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("San Francisco");
    tz.timeZone = QTimeZone("America/Costa_Rica");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("San José");
    tz.timeZone = QTimeZone("America/Costa_Rica");
    tz.country = tr("Costa Rica");
    m_timeZones.append(tz);

    tz.cityName = tr("San Juan");
    tz.timeZone = QTimeZone("America/Puerto_Rico");
    tz.country = tr("Puerto Rico");
    m_timeZones.append(tz);

    tz.cityName = tr("San Marino");
    tz.timeZone = QTimeZone("Europe/San_Marino");
    tz.country = tr("San Marino");
    m_timeZones.append(tz);

    tz.cityName = tr("San Salvador");
    tz.timeZone = QTimeZone("America/El_Salvador");
    tz.country = tr("El Salvador");
    m_timeZones.append(tz);

    tz.cityName = tr("Sanaa");
    tz.timeZone = QTimeZone("Asia/Aden");
    tz.country = tr("Yemen");
    m_timeZones.append(tz);

    tz.cityName = tr("Santiago");
    tz.timeZone = QTimeZone("America/Santiago");
    tz.country = tr("Chile");
    m_timeZones.append(tz);

    tz.cityName = tr("Santo Domingo");
    tz.timeZone = QTimeZone("America/Santo_Domingo");
    tz.country = tr("Dominican Republic");
    m_timeZones.append(tz);

    tz.cityName = tr("São Paulo");
    tz.timeZone = QTimeZone("America/Sao_Paulo");
    tz.country = tr("Brazil");
    m_timeZones.append(tz);

    tz.cityName = tr("São Tomé");
    tz.timeZone = QTimeZone("Africa/Sao_Tome");
    tz.country = tr("São Tomé and Príncipe");
    m_timeZones.append(tz);

    tz.cityName = tr("Sarajevo");
    tz.timeZone = QTimeZone("Europe/Sarajevo");
    tz.country = tr("Bosnia and Herzegovina");
    m_timeZones.append(tz);

    tz.cityName = tr("Saskatchewan");
    tz.timeZone = QTimeZone("America/Regina");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Seattle");
    tz.timeZone = QTimeZone("America/Los_Angeles");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Seoul");
    tz.timeZone = QTimeZone("Asia/Seoul");
    tz.country = tr("South Korea");
    m_timeZones.append(tz);

    tz.cityName = tr("Shanghai");
    tz.timeZone = QTimeZone("Asia/Shanghai");
    tz.country = tr("China");
    m_timeZones.append(tz);

    tz.cityName = tr("Singapore");
    tz.timeZone = QTimeZone("Asia/Singapore");
    tz.country = tr("Singapore");
    m_timeZones.append(tz);

    tz.cityName = tr("Simferopol’");
    tz.timeZone = QTimeZone("Europe/Simferopol");
    tz.country = tr("Ukraine");
    m_timeZones.append(tz);

    tz.cityName = tr("Skopje");
    tz.timeZone = QTimeZone("Europe/Skopje");
    tz.country = tr("Macedonia");
    m_timeZones.append(tz);

    tz.cityName = tr("Sofia");
    tz.timeZone = QTimeZone("Europe/Sofia");
    tz.country = tr("Bulgaria");
    m_timeZones.append(tz);

    tz.cityName = tr("St.Johns");
    tz.timeZone = QTimeZone("America/St_Johns");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("St.Kitts");
    tz.timeZone = QTimeZone("America/St_Kitts");
    tz.country = tr("Saint Kitts and Nevis");
    m_timeZones.append(tz);

    tz.cityName = tr("St.Louis");
    tz.timeZone = QTimeZone("America/Chicago");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Stanley");
    tz.timeZone = QTimeZone("Atlantic/Stanley");
    tz.country = tr("Falkland Islands");
    m_timeZones.append(tz);

    tz.cityName = tr("Stockholm");
    tz.timeZone = QTimeZone("Europe/Stockholm");
    tz.country = tr("Sweden");
    m_timeZones.append(tz);

    tz.cityName = tr("Suva");
    tz.timeZone = QTimeZone("Pacific/Fiji");
    tz.country = tr("Fiji");
    m_timeZones.append(tz);

    tz.cityName = tr("Sydney");
    tz.timeZone = QTimeZone("Australia/Sydney");
    tz.country = tr("Australia");
    m_timeZones.append(tz);

    tz.cityName = tr("Taipei");
    tz.timeZone = QTimeZone("Asia/Taipei");
    tz.country = tr("Taiwan");
    m_timeZones.append(tz);

    tz.cityName = tr("Tallinn");
    tz.timeZone = QTimeZone("Europe/Tallinn");
    tz.country = tr("Estonia");
    m_timeZones.append(tz);

    tz.cityName = tr("Tehran");
    tz.timeZone = QTimeZone("Asia/Tehran");
    tz.country = tr("Iran");
    m_timeZones.append(tz);

    tz.cityName = tr("Tokyo");
    tz.timeZone = QTimeZone("Asia/Tokyo");
    tz.country = tr("Japan");
    m_timeZones.append(tz);

    tz.cityName = tr("Toronto");
    tz.timeZone = QTimeZone("America/Toronto");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Tripoli");
    tz.timeZone = QTimeZone("Africa/Tripoli");
    tz.country = tr("Libyra");
    m_timeZones.append(tz);

    tz.cityName = tr("Tunis");
    tz.timeZone = QTimeZone("Africa/Tunis");
    tz.country = tr("Tunisia");
    m_timeZones.append(tz);

    tz.cityName = tr("Ulan Bator");
    tz.timeZone = QTimeZone("Asia/Ulan_Bator");
    tz.country = tr("Mongolia");
    m_timeZones.append(tz);

    tz.cityName = tr("UTC");
    tz.timeZone = QTimeZone("UTC");
    tz.country = tr("UTC");
    m_timeZones.append(tz);

    tz.cityName = tr("Vancouver");
    tz.timeZone = QTimeZone("America/Vancouver");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Vatican City");
    tz.timeZone = QTimeZone("Europe/Vatican");
    tz.country = tr("Vatican City");
    m_timeZones.append(tz);

    tz.cityName = tr("Vevay");
    tz.timeZone = QTimeZone("America/Indiana/Vevay");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Vienna");
    tz.timeZone = QTimeZone("Europe/Vienna");
    tz.country = tr("Austria");
    m_timeZones.append(tz);

    tz.cityName = tr("Vilnius");
    tz.timeZone = QTimeZone("Europe/Vilnius");
    tz.country = tr("Lithuania");
    m_timeZones.append(tz);

    tz.cityName = tr("Vincennes");
    tz.timeZone = QTimeZone("America/Indiana/Vincennes");
    tz.country = tr("France");
    m_timeZones.append(tz);

    tz.cityName = tr("Warsaw");
    tz.timeZone = QTimeZone("Europe/Warsaw");
    tz.country = tr("Poland");
    m_timeZones.append(tz);

    tz.cityName = tr("Washington D.C");
    tz.timeZone = QTimeZone("America/New_York");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Winamac");
    tz.timeZone = QTimeZone("America/Indiana/Winamac");
    tz.country = tr("United States");
    m_timeZones.append(tz);

    tz.cityName = tr("Winnipeg");
    tz.timeZone = QTimeZone("America/Winnipeg");
    tz.country = tr("Canada");
    m_timeZones.append(tz);

    tz.cityName = tr("Wrocław");
    tz.timeZone = QTimeZone("Europe/Warsaw");
    tz.country = tr("Poland");
    m_timeZones.append(tz);

    tz.cityName = tr("Zagreb");
    tz.timeZone = QTimeZone("Europe/Zagreb");
    tz.country = tr("Croatia");
    m_timeZones.append(tz);

    tz.cityName = tr("Zürich");
    tz.timeZone = QTimeZone("Europe/Zurich");
    tz.country = tr("Switzerland");
    m_timeZones.append(tz);

    // Let QML know model is reusable again
    endResetModel();
}
