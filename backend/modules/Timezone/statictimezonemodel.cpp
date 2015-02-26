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

void StaticTimeZoneModel::addCity(const QString &city, const QString &timezone, const QString &country) {
    TimeZone tz;
    tz.cityName = city;
    tz.country = country;
    tz.timeZone = QTimeZone(timezone.toLatin1());
    m_timeZones.append(tz);
}

void StaticTimeZoneModel::loadDefaultCityList()
{
    // Let QML know model is being reset and rebuilt
    beginResetModel();

    m_timeZones.clear();

    addCity(tr("Abidjan"), "Africa/Abidjan", tr("Ivory Coast"));
    addCity(tr("Accra"), "Africa/Accra", tr("Ghana"));
    addCity(tr("Addis Ababa"), "Africa/Addis_Ababa", tr("Ethiopia"));
    addCity(tr("Adelaide"), "Australia/Adelaide", tr("Australia"));
    addCity(tr("Albuquerque"), "America/Denver", tr("United States"));
    addCity(tr("Algiers"), "Africa/Algiers", tr("Algeria"));
    addCity(tr("Almaty"), "Asia/Almaty", tr("Kazakhstan"));
    addCity(tr("Amman"), "Asia/Amman", tr("Jordan"));
    addCity(tr("Amsterdam"), "Europe/Amsterdam", tr("Netherlands"));
    addCity(tr("Anadyr"), "Asia/Anadyr", tr("Russia"));
    addCity(tr("Anchorage"), "America/Anchorage", tr("United States"));
    addCity(tr("Andorra"), "Europe/Andorra", tr("Andorra"));
    addCity(tr("Ankara"), "Europe/Istanbul", tr("Turkey"));
    addCity(tr("Ann Arbor"), "America/Detroit", tr("United States"));
    addCity(tr("Antananarivo"), "Indian/Antananarivo", tr("Madagascar"));
    addCity(tr("Aqtau"), "Asia/Aqtau", tr("Kazakhstan"));
    addCity(tr("Aruba"), "America/Aruba", tr("Aruba"));
    addCity(tr("Asunción"), "America/Asuncion", tr("Paraguay"));
    addCity(tr("Athens"), "Europe/Athens", tr("Greece"));
    addCity(tr("Atlanta"), "America/New_York", tr("United States"));
    addCity(tr("Auckland"), "Pacific/Auckland", tr("New Zealand"));
    addCity(tr("Austin"), "America/Chicago", tr("United States"));

    addCity(tr("Baghdad"), "Asia/Baghdad", tr("Iraq"));
    addCity(tr("Bahrain"), "Asia/Bahrain", tr("Bahrain"));
    addCity(tr("Baku"), "Asia/Baku", tr("Azerbaijan"));
    addCity(tr("Baltimore"), "America/New_York", tr("United States"));
    addCity(tr("Bangalore"), "Asia/Kolkata", tr("India"));
    addCity(tr("Bangkok"), "Asia/Bangkok", tr("Thailand"));
    addCity(tr("Barbados"), "America/Barbados", tr("Barbados"));
    addCity(tr("Barcelona"), "Europe/Madrid", tr("Spain"));
    addCity(tr("Beijing"), "Asia/Shanghai", tr("China"));
    addCity(tr("Beirut"), "Asia/Beirut", tr("Lebanon"));
    addCity(tr("Belfast"), "Europe/Belfast", tr("United Kingdom"));
    addCity(tr("Belgrade"), "Europe/Belgrade", tr("Serbia"));
    addCity(tr("Belize"), "America/Belize", tr("Belize"));
    addCity(tr("Belo Horizonte"), "America/Sao_Paulo", tr("Brazil"));
    addCity(tr("Berlin"), "Europe/Berlin", tr("Germany"));
    addCity(tr("Bermuda"), "Atlantic/Bermuda", tr("Bermuda"));
    addCity(tr("Beulah"), "America/North_Dakota/Beulah", tr("United States"));
    addCity(tr("Black Rock City"), "America/Chicago", tr("United States"));
    addCity(tr("Blantyre"), "Africa/Blantyre", tr("Malawi"));
    addCity(tr("Bogotá"), "America/Bogota", tr("Colombia"));
    addCity(tr("Boston"), "America/New_York", tr("United States"));
    addCity(tr("Boulder"), "America/Denver", tr("United States"));
    addCity(tr("Brasília"), "America/Sao_Paulo", tr("Brazil"));
    addCity(tr("Bratislava"), "Europe/Bratislava", tr("Slovakia"));
    addCity(tr("Brazzaville"), "Africa/Brazzaville", tr("Republic of the Congo"));
    addCity(tr("Brisbane"), "Australia/Brisbane", tr("Australia"));
    addCity(tr("Brussels"), "Europe/Brussels", tr("Belgium"));
    addCity(tr("Bucharest"), "Europe/Bucharest", tr("Romania"));
    addCity(tr("Budapest"), "Europe/Budapest", tr("Hungary"));
    addCity(tr("Buenos Aires"), "America/Argentina/Buenos_Aires", tr("Argentina"));

    addCity(tr("Cairo"), "Africa/Cairo", tr("Egypt"));
    addCity(tr("Calcutta"), "Asia/Calcutta", tr("India"));
    addCity(tr("Calgary"), "America/Edmonton", tr("Canada"));
    addCity(tr("Cambridge"), "Europe/London", tr("United Kingdom"));
    addCity(tr("Canary"), "Atlantic/Canary", tr("Australia"));
    addCity(tr("Canberra"), "Australia/Canberra", tr("Australia"));
    addCity(tr("Cancún"), "America/Cancun", tr("Mexico"));
    addCity(tr("Cape Town"), "Africa/Johannesburg", tr("South Africa"));
    addCity(tr("Caracas"), "America/Caracas", tr("Venezuela"));
    addCity(tr("Casablanca"), "Africa/Casablanca", tr("Morocco"));
    addCity(tr("Cayman Palms"), "America/Cayman", tr("Cayman Islands"));
    addCity(tr("Chicago"), "America/Chicago", tr("United States"));
    addCity(tr("Chihuahua"), "America/Chihuahua", tr("Mexico"));
    addCity(tr("Chişinău"), "Europe/Chisinau", tr("Moldova"));
    addCity(tr("Cincinnati"), "America/New_York", tr("United States"));
    addCity(tr("Cleveland"), "America/New_York", tr("United States"));
    addCity(tr("Colombo"), "Asia/Colombo", tr("Sri Lanka"));
    addCity(tr("Columbus"), "America/New_York", tr("United States"));
    addCity(tr("Conakry"), "Africa/Conakry", tr("Guinea"));
    addCity(tr("Copenhagen"), "Europe/Copenhagen", tr("Denmark"));
    addCity(tr("Costa Rica"), "America/Costa_Rica", tr("Costa Rica"));
    addCity(tr("Curaçao"), "America/Curacao", tr("Curacao"));

    addCity(tr("Dakar"), "Africa/Dakar", tr("Senegal"));
    addCity(tr("Dallas"), "America/Chicago", tr("United States"));
    addCity(tr("Damascus"), "Asia/Damascus", tr("Syria"));
    addCity(tr("Dar es Salaam"), "Africa/Dar_es_Salaam", tr("Tanzania"));
    addCity(tr("Darwin"), "Australia/Darwin", tr("Australia"));
    addCity(tr("Dawson Creek"), "America/Dawson_Creek", tr("Canada"));
    addCity(tr("Delhi"), "Asia/Kolkata", tr("India"));
    addCity(tr("Denver"), "America/Denver", tr("United States"));
    addCity(tr("Detroit"), "America/Detroit", tr("United States"));
    addCity(tr("Dhaka"), "Asia/Dhaka", tr("Bangladesh"));
    addCity(tr("Djibouti"), "Africa/Djibouti", tr("Djibouti"));
    addCity(tr("Doha"), "Asia/Qatar", tr("Qatar"));
    addCity(tr("Dominica"), "America/Dominica", tr("Dominica"));
    addCity(tr("Dubai"), "Asia/Dubai", tr("United Arab Emirates"));
    addCity(tr("Dublin"), "Europe/Dublin", tr("Ireland"));

    addCity(tr("Easter Island"), "Pacific/Easter", tr("Chile"));
    addCity(tr("Edmonton"), "America/Edmonton", tr("Canada"));
    addCity(tr("El Salvador"), "America/El_Salvador", tr("El Salvador"));

    addCity(tr("Fiji"), "Pacific/Fiji", tr("Fiji"));
    addCity(tr("Fortaleza"), "America/Fortaleza", tr("Brazil"));
    addCity(tr("Frankfurt"), "Europe/Berlin", tr("Germany"));
    addCity(tr("Freetown"), "Africa/Freetown", tr("Sierra Leone"));

    addCity(tr("Gaborone"), "Africa/Gaborone", tr("Botswana"));
    addCity(tr("Gaza"), "Asia/Gaza", tr("Palestine"));
    addCity(tr("Gibraltar"), "Europe/Gibraltar", tr("Gibraltar"));
    addCity(tr("Grand Turk"), "America/Grand_Turk", tr("Turks and Caicos Islands"));
    addCity(tr("Grenada"), "America/Grenada", tr("Grenada"));
    addCity(tr("Guam"), "Pacific/Guam", tr("Guam"));
    addCity(tr("Guangzhou"), "Asia/Shanghai", tr("China"));
    addCity(tr("Guatemala"), "America/Guatemala", tr("Guatemala"));
    addCity(tr("Gurgaon"), "Asia/Kolkata", tr("India"));
    addCity(tr("Guyana"), "America/Guyana", tr("Guyana"));

    addCity(tr("Haifa"), "Asia/Jerusalem", tr("Israel"));
    addCity(tr("Halifax"), "America/Halifax", tr("Canada"));
    addCity(tr("Hamburg"), "Europe/Berlin", tr("Germany"));
    addCity(tr("Hanoi"), "Asia/Ho_Chi_Minh", tr("Vietnam"));
    addCity(tr("Harare"), "Africa/Harare", tr("Zimbabwe"));
    addCity(tr("Havana"), "America/Havana", tr("Cuba"));
    addCity(tr("Hebron"), "Asia/Hebron", tr("Palestine"));
    addCity(tr("Helsinki"), "Europe/Helsinki", tr("Finland"));
    addCity(tr("Ho Chi Minh City"), "Asia/Ho_Chi_Minh", tr("Vietnam"));
    addCity(tr("Hong Kong"), "Asia/Hong_Kong", tr("Hong Kong"));
    addCity(tr("Honolulu"), "Pacific/Honolulu", tr("United States"));
    addCity(tr("Houston"), "America/Chicago", tr("United States"));
    addCity(tr("Hyderabad"), "Asia/Kolkata", tr("India"));

    addCity(tr("Indianapolis"), "America/Indiana/Indianapolis", tr("United States"));
    addCity(tr("Islamabad"), "Asia/Karachi", tr("Pakistan"));
    addCity(tr("Isle of Man"), "Europe/Isle_of_Man", tr("Isle of Man"));
    addCity(tr("Istanbul"), "Europe/Istanbul", tr("Turkey"));

    addCity(tr("Jacksonville"), "America/New_York", tr("United States"));
    addCity(tr("Jakarta"), "Asia/Jakarta", tr("Indonesia"));
    addCity(tr("Jerusalem"), "Asia/Jerusalem", tr("Israel"));
    addCity(tr("Johannesburg"), "Africa/Johannesburg", tr("South Africa"));

    addCity(tr("Kabul"), "Asia/Kabul", tr("Afghanistan"));
    addCity(tr("Kampala"), "Africa/Kampala", tr("Uganda"));
    addCity(tr("Karachi"), "Asia/Karachi", tr("Pakistan"));
    addCity(tr("Khartoum"), "Africa/Khartoum", tr("Sudan"));
    addCity(tr("Kiev"), "Europe/Kiev", tr("Ukraine"));
    addCity(tr("Kigali"), "Africa/Kigali", tr("Rwanda"));
    addCity(tr("Kingston"), "America/Toronto", tr("Canada"));
    addCity(tr("Kinshasa"), "Africa/Kinshasa", tr("Democratic Republic of the Congo"));
    addCity(tr("Kiritimati"), "Pacific/Kiritimati", tr("Kiribati"));
    addCity(tr("Kirkland"), "America/Montreal", tr("Canada"));
    addCity(tr("Knox"), "Australia/Melbourne", tr("Australia"));
    addCity(tr("Knoxville"), "America/New_York", tr("United States"));
    addCity(tr("Kraków"), "Europe/Warsaw", tr("Poland"));
    addCity(tr("Kuala Lumpur"), "Asia/Kuala_Lumpur", tr("Malaysia"));
    addCity(tr("Kuwait City"), "Asia/Kuwait", tr("Kuwait"));
    addCity(tr("Kyiv"), "Europe/Kiev", tr("Ukraine"));

    addCity(tr("Lagos"), "Africa/Lagos", tr("Nigeria"));
    addCity(tr("Lahore"), "Asia/Karachi", tr("Pakistan"));
    addCity(tr("Las Vegas"), "America/Los_Angeles", tr("United States"));
    addCity(tr("Lima"), "America/Lima", tr("Peru"));
    addCity(tr("Lisbon"), "Europe/Lisbon", tr("Portugal"));
    addCity(tr("London"), "Europe/London", tr("United Kingdom"));
    addCity(tr("Longyearbyen"), "Arctic/Longyearbyen", tr("Svalbard and Jan Mayen"));
    addCity(tr("Los Angeles"), "America/Los_Angeles", tr("United States"));
    addCity(tr("Louisville"), "America/Kentucky/Louisville", tr("United States"));
    addCity(tr("Luxembourg"), "Europe/Luxembourg", tr("Luxembourg"));

    addCity(tr("Macau"), "Asia/Macau", tr("Macao"));
    addCity(tr("Madison"), "America/Chicago", tr("United States"));
    addCity(tr("Madrid"), "Europe/Madrid", tr("Spain"));
    addCity(tr("Maldives"), "Indian/Maldives", tr("Maldives"));
    addCity(tr("Malta"), "Europe/Malta", tr("Malta"));
    addCity(tr("Managua"), "America/Managua", tr("Nicaragua"));
    addCity(tr("Manchester"), "Europe/London", tr("United Kingdom"));
    addCity(tr("Manila"), "Asia/Manila", tr("Philippines"));
    addCity(tr("Marengo"), "America/Indiana/Marengo", tr("United States"));
    addCity(tr("Martinique"), "America/Martinique", tr("Canada"));
    addCity(tr("Maseru"), "Africa/Maseru", tr("Lesotho"));
    addCity(tr("Melbourne"), "Australia/Melbourne", tr("Australia"));
    addCity(tr("Memphis"), "America/Chicago", tr("United States"));
    addCity(tr("Mendoza"), "America/Argentina/Mendoza", tr("Argentina"));
    addCity(tr("Metlakatla"), "America/Metlakatla", tr("United States"));
    addCity(tr("Mexico City"), "America/Mexico_City", tr("Mexico"));
    addCity(tr("Miami"), "America/New_York", tr("United States"));
    addCity(tr("Milan"), "Europe/Rome", tr("Italy"));
    addCity(tr("Milwaukee"), "America/Chicago", tr("United States"));
    addCity(tr("Minneapolis"), "America/Chicago", tr("United States"));
    addCity(tr("Minsk"), "Europe/Minsk", tr("Belarus"));
    addCity(tr("Mogadishu"), "Africa/Mogadishu", tr("Somalia"));
    addCity(tr("Monrovia"), "Africa/Monrovia", tr("Liberia"));
    addCity(tr("Monaco"), "Europe/Monaco", tr("Monaco"));
    addCity(tr("Monterrey"), "America/Monterrey", tr("Mexico"));
    addCity(tr("Montevideo"), "America/Montevideo", tr("Uruguay"));
    addCity(tr("Montreal"), "America/Montreal", tr("Canada"));
    addCity(tr("Moscow"), "Europe/Moscow", tr("Russia"));
    addCity(tr("Mountain View"), "America/Los_Angeles", tr("United States"));
    addCity(tr("Mumbai"), "Asia/Kolkata", tr("India"));
    addCity(tr("Munich"), "Europe/Berlin", tr("Germany"));
    addCity(tr("Muscat"), "Asia/Muscat", tr("Oman"));

    addCity(tr("Nairobi"), "Africa/Nairobi", tr("Kenya"));
    addCity(tr("Nashville"), "America/Chicago", tr("United States"));
    addCity(tr("Nassau"), "America/Nassau", tr("Bahamas"));
    addCity(tr("New Orleans"), "America/Chicago", tr("United States"));
    addCity(tr("New Salem"), "America/North_Dakota/New_Salem", tr("United States"));
    addCity(tr("New South Wales"), "Australia/Sydney", tr("Australia"));
    addCity(tr("New York"), "America/New_York", tr("United States"));
    addCity(tr("Newfoundland"), "America/St_Johns", tr("United States"));
    addCity(tr("Nouméa"), "Pacific/Noumea", tr("New Caledonia"));
    addCity(tr("Nuestra Señora de La Paz"), "America/Bogota", tr("Colombia"));

    addCity(tr("Oklahoma City"), "America/Chicago", tr("United States"));
    addCity(tr("Osaka"), "Asia/Tokyo", tr("Japan"));
    addCity(tr("Oslo"), "Europe/Oslo", tr("Norway"));
    addCity(tr("Ottawa"), "America/Toronto", tr("Canada"));
    addCity(tr("Oulu"), "Europe/Helsinki", tr("Finland"));

    addCity(tr("Panamá"), "America/Panama", tr("Panama"));
    addCity(tr("Paramaribo"), "America/Paramaribo", tr("Suriname"));
    addCity(tr("Paris"), "Europe/Paris", tr("France"));
    addCity(tr("Perth"), "Australia/Perth", tr("Australia"));
    addCity(tr("Petersburg"), "America/Indiana/Petersburg", tr("Russia"));
    addCity(tr("Philadelphia"), "America/New_York", tr("United States"));
    addCity(tr("Phnom Penh"), "Asia/Phnom_Penh", tr("Cambodia"));
    addCity(tr("Phoenix"), "America/Phoenix", tr("United States"));
    addCity(tr("Pittsburgh"), "America/New_York", tr("United States"));
    addCity(tr("Port of Spain"), "America/Port_of_Spain", tr("Trinidad and Tobago"));
    addCity(tr("Port au Prince"), "America/Port-au-Prince", tr("Haiti"));
    addCity(tr("Portland"), "America/Los_Angeles", tr("United States"));
    addCity(tr("Prague"), "Europe/Prague", tr("Czech"));
    addCity(tr("Pyongyang"), "Asia/Pyongyang", tr("North Korea"));

    addCity(tr("Queensland"), "Australia/Brisbane", tr("United States"));
    addCity(tr("Quito"), "America/Guayaquil", tr("Ecuador"));

    addCity(tr("Rangoon"), "Asia/Rangoon", tr("Myanmar"));
    addCity(tr("Reno"), "America/Los_Angeles", tr("United States"));
    addCity(tr("Reston"), "America/New_York", tr("United States"));
    addCity(tr("Reykjavík"), "Atlantic/Reykjavik", tr("Iceland"));
    addCity(tr("Riga"), "Europe/Riga", tr("Latvia"));
    addCity(tr("Rio de Janeiro"), "America/Sao_Paulo", tr("Brazil"));
    addCity(tr("Riyadh"), "Asia/Riyadh", tr("Saudi Arabia"));
    addCity(tr("Rome"), "Europe/Rome", tr("Italy"));

    addCity(tr("Sacramento"), "America/Los_Angeles", tr("United States"));
    addCity(tr("Salt Lake City"), "America/Denver", tr("United States"));
    addCity(tr("Samoa"), "Pacific/Apia", tr("Samoa"));
    addCity(tr("San Antonio"), "America/Chicago", tr("United States"));
    addCity(tr("San Diego"), "America/Los_Angeles", tr("United States"));
    addCity(tr("San Francisco"), "America/Costa_Rica", tr("United States"));
    addCity(tr("San José"), "America/Costa_Rica", tr("Costa Rica"));
    addCity(tr("San Juan"), "America/Puerto_Rico", tr("Puerto Rico"));
    addCity(tr("San Marino"), "Europe/San_Marino", tr("San Marino"));
    addCity(tr("San Salvador"), "America/El_Salvador", tr("El Salvador"));
    addCity(tr("Sanaa"), "Asia/Aden", tr("Yemen"));
    addCity(tr("Santiago"), "America/Santiago", tr("Chile"));
    addCity(tr("Santo Domingo"), "America/Santo_Domingo", tr("Dominican Republic"));
    addCity(tr("São Paulo"), "America/Sao_Paulo", tr("Brazil"));
    addCity(tr("São Tomé"), "Africa/Sao_Tome", tr("São Tomé and Príncipe"));
    addCity(tr("Sarajevo"), "Europe/Sarajevo", tr("Bosnia and Herzegovina"));
    addCity(tr("Saskatchewan"), "America/Regina", tr("Canada"));
    addCity(tr("Seattle"), "America/Los_Angeles", tr("United States"));
    addCity(tr("Seoul"), "Asia/Seoul", tr("South Korea"));
    addCity(tr("Shanghai"), "Asia/Shanghai", tr("China"));
    addCity(tr("Singapore"), "Asia/Singapore", tr("Singapore"));
    addCity(tr("Simferopol’"), "Europe/Simferopol", tr("Ukraine"));
    addCity(tr("Skopje"), "Europe/Skopje", tr("Macedonia"));
    addCity(tr("Sofia"), "Europe/Sofia", tr("Bulgaria"));
    addCity(tr("St.Johns"), "America/St_Johns", tr("Canada"));
    addCity(tr("St.Kitts"), "America/St_Kitts", tr("Saint Kitts and Nevis"));
    addCity(tr("St.Louis"), "America/Chicago", tr("United States"));
    addCity(tr("Stanley"), "Atlantic/Stanley", tr("Falkland Islands"));
    addCity(tr("Stockholm"), "Europe/Stockholm", tr("Sweden"));
    addCity(tr("Suva"), "Pacific/Fiji", tr("Fiji"));
    addCity(tr("Sydney"), "Australia/Sydney", tr("Australia"));

    addCity(tr("Taipei"), "Asia/Taipei", tr("Taiwan"));
    addCity(tr("Tallinn"), "Europe/Tallinn", tr("Estonia"));
    addCity(tr("Tehran"), "Asia/Tehran", tr("Iran"));
    addCity(tr("Tokyo"), "Asia/Tokyo", tr("Japan"));
    addCity(tr("Toronto"), "America/Toronto", tr("Canada"));
    addCity(tr("Tripoli"), "Africa/Tripoli", tr("Libyra"));
    addCity(tr("Tunis"), "Africa/Tunis", tr("Tunisia"));

    addCity(tr("Ulan Bator"), "Asia/Ulan_Bator", tr("Mongolia"));
    addCity(tr("UTC"), "UTC", tr("UTC"));

    addCity(tr("Vancouver"), "America/Vancouver", tr("Canada"));
    addCity(tr("Vatican City"), "Europe/Vatican", tr("Vatican City"));
    addCity(tr("Vevay"), "America/Indiana/Vevay", tr("United States"));
    addCity(tr("Vienna"), "Europe/Vienna", tr("Austria"));
    addCity(tr("Vilnius"), "Europe/Vilnius", tr("Lithuania"));
    addCity(tr("Vincennes"), "America/Indiana/Vincennes", tr("France"));

    addCity(tr("Warsaw"), "Europe/Warsaw", tr("Poland"));
    addCity(tr("Washington D.C"), "America/New_York", tr("United States"));
    addCity(tr("Winamac"), "America/Indiana/Winamac", tr("United States"));
    addCity(tr("Winnipeg"), "America/Winnipeg", tr("Canada"));
    addCity(tr("Wrocław"), "Europe/Warsaw", tr("Poland"));

    addCity(tr("Zagreb"), "Europe/Zagreb", tr("Croatia"));
    addCity(tr("Zürich"), "Europe/Zurich", tr("Switzerland"));

    // Let QML know model is reusable again
    endResetModel();
}
