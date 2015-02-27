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

    addCity(gettext("Abidjan"), "Africa/Abidjan", gettext("Ivory Coast"));
    addCity(gettext("Accra"), "Africa/Accra", gettext("Ghana"));
    addCity(gettext("Addis Ababa"), "Africa/Addis_Ababa", gettext("Ethiopia"));
    addCity(gettext("Adelaide"), "Australia/Adelaide", gettext("Australia"));
    addCity(gettext("Albuquerque"), "America/Denver", gettext("United States"));
    addCity(gettext("Algiers"), "Africa/Algiers", gettext("Algeria"));
    addCity(gettext("Almaty"), "Asia/Almaty", gettext("Kazakhstan"));
    addCity(gettext("Amman"), "Asia/Amman", gettext("Jordan"));
    addCity(gettext("Amsterdam"), "Europe/Amsterdam", gettext("Netherlands"));
    addCity(gettext("Anadyr"), "Asia/Anadyr", gettext("Russia"));
    addCity(gettext("Anchorage"), "America/Anchorage", gettext("United States"));
    addCity(gettext("Andorra"), "Europe/Andorra", gettext("Andorra"));
    addCity(gettext("Ankara"), "Europe/Istanbul", gettext("Turkey"));
    addCity(gettext("Ann Arbor"), "America/Detroit", gettext("United States"));
    addCity(gettext("Antananarivo"), "Indian/Antananarivo", gettext("Madagascar"));
    addCity(gettext("Aqtau"), "Asia/Aqtau", gettext("Kazakhstan"));
    addCity(gettext("Aruba"), "America/Aruba", gettext("Aruba"));
    addCity(gettext("Asunción"), "America/Asuncion", gettext("Paraguay"));
    addCity(gettext("Athens"), "Europe/Athens", gettext("Greece"));
    addCity(gettext("Atlanta"), "America/New_York", gettext("United States"));
    addCity(gettext("Auckland"), "Pacific/Auckland", gettext("New Zealand"));
    addCity(gettext("Austin"), "America/Chicago", gettext("United States"));

    addCity(gettext("Baghdad"), "Asia/Baghdad", gettext("Iraq"));
    addCity(gettext("Bahrain"), "Asia/Bahrain", gettext("Bahrain"));
    addCity(gettext("Baku"), "Asia/Baku", gettext("Azerbaijan"));
    addCity(gettext("Baltimore"), "America/New_York", gettext("United States"));
    addCity(gettext("Bangalore"), "Asia/Kolkata", gettext("India"));
    addCity(gettext("Bangkok"), "Asia/Bangkok", gettext("Thailand"));
    addCity(gettext("Barbados"), "America/Barbados", gettext("Barbados"));
    addCity(gettext("Barcelona"), "Europe/Madrid", gettext("Spain"));
    addCity(gettext("Beijing"), "Asia/Shanghai", gettext("China"));
    addCity(gettext("Beirut"), "Asia/Beirut", gettext("Lebanon"));
    addCity(gettext("Belfast"), "Europe/Belfast", gettext("United Kingdom"));
    addCity(gettext("Belgrade"), "Europe/Belgrade", gettext("Serbia"));
    addCity(gettext("Belize"), "America/Belize", gettext("Belize"));
    addCity(gettext("Belo Horizonte"), "America/Sao_Paulo", gettext("Brazil"));
    addCity(gettext("Berlin"), "Europe/Berlin", gettext("Germany"));
    addCity(gettext("Bermuda"), "Atlantic/Bermuda", gettext("Bermuda"));
    addCity(gettext("Beulah"), "America/North_Dakota/Beulah", gettext("United States"));
    addCity(gettext("Black Rock City"), "America/Chicago", gettext("United States"));
    addCity(gettext("Blantyre"), "Africa/Blantyre", gettext("Malawi"));
    addCity(gettext("Bogotá"), "America/Bogota", gettext("Colombia"));
    addCity(gettext("Boston"), "America/New_York", gettext("United States"));
    addCity(gettext("Boulder"), "America/Denver", gettext("United States"));
    addCity(gettext("Brasília"), "America/Sao_Paulo", gettext("Brazil"));
    addCity(gettext("Bratislava"), "Europe/Bratislava", gettext("Slovakia"));
    addCity(gettext("Brazzaville"), "Africa/Brazzaville", gettext("Republic of the Congo"));
    addCity(gettext("Brisbane"), "Australia/Brisbane", gettext("Australia"));
    addCity(gettext("Brussels"), "Europe/Brussels", gettext("Belgium"));
    addCity(gettext("Bucharest"), "Europe/Bucharest", gettext("Romania"));
    addCity(gettext("Budapest"), "Europe/Budapest", gettext("Hungary"));
    addCity(gettext("Buenos Aires"), "America/Argentina/Buenos_Aires", gettext("Argentina"));

    addCity(gettext("Cairo"), "Africa/Cairo", gettext("Egypt"));
    addCity(gettext("Calcutta"), "Asia/Calcutta", gettext("India"));
    addCity(gettext("Calgary"), "America/Edmonton", gettext("Canada"));
    addCity(gettext("Cambridge"), "Europe/London", gettext("United Kingdom"));
    addCity(gettext("Canary"), "Atlantic/Canary", gettext("Australia"));
    addCity(gettext("Canberra"), "Australia/Canberra", gettext("Australia"));
    addCity(gettext("Cancún"), "America/Cancun", gettext("Mexico"));
    addCity(gettext("Cape Town"), "Africa/Johannesburg", gettext("South Africa"));
    addCity(gettext("Caracas"), "America/Caracas", gettext("Venezuela"));
    addCity(gettext("Casablanca"), "Africa/Casablanca", gettext("Morocco"));
    addCity(gettext("Cayman Palms"), "America/Cayman", gettext("Cayman Islands"));
    addCity(gettext("Chicago"), "America/Chicago", gettext("United States"));
    addCity(gettext("Chihuahua"), "America/Chihuahua", gettext("Mexico"));
    addCity(gettext("Chişinău"), "Europe/Chisinau", gettext("Moldova"));
    addCity(gettext("Cincinnati"), "America/New_York", gettext("United States"));
    addCity(gettext("Cleveland"), "America/New_York", gettext("United States"));
    addCity(gettext("Colombo"), "Asia/Colombo", gettext("Sri Lanka"));
    addCity(gettext("Columbus"), "America/New_York", gettext("United States"));
    addCity(gettext("Conakry"), "Africa/Conakry", gettext("Guinea"));
    addCity(gettext("Copenhagen"), "Europe/Copenhagen", gettext("Denmark"));
    addCity(gettext("Costa Rica"), "America/Costa_Rica", gettext("Costa Rica"));
    addCity(gettext("Curaçao"), "America/Curacao", gettext("Curacao"));

    addCity(gettext("Dakar"), "Africa/Dakar", gettext("Senegal"));
    addCity(gettext("Dallas"), "America/Chicago", gettext("United States"));
    addCity(gettext("Damascus"), "Asia/Damascus", gettext("Syria"));
    addCity(gettext("Dar es Salaam"), "Africa/Dar_es_Salaam", gettext("Tanzania"));
    addCity(gettext("Darwin"), "Australia/Darwin", gettext("Australia"));
    addCity(gettext("Dawson Creek"), "America/Dawson_Creek", gettext("Canada"));
    addCity(gettext("Delhi"), "Asia/Kolkata", gettext("India"));
    addCity(gettext("Denver"), "America/Denver", gettext("United States"));
    addCity(gettext("Detroit"), "America/Detroit", gettext("United States"));
    addCity(gettext("Dhaka"), "Asia/Dhaka", gettext("Bangladesh"));
    addCity(gettext("Djibouti"), "Africa/Djibouti", gettext("Djibouti"));
    addCity(gettext("Doha"), "Asia/Qatar", gettext("Qatar"));
    addCity(gettext("Dominica"), "America/Dominica", gettext("Dominica"));
    addCity(gettext("Dubai"), "Asia/Dubai", gettext("United Arab Emirates"));
    addCity(gettext("Dublin"), "Europe/Dublin", gettext("Ireland"));

    addCity(gettext("Easter Island"), "Pacific/Easter", gettext("Chile"));
    addCity(gettext("Edmonton"), "America/Edmonton", gettext("Canada"));
    addCity(gettext("El Salvador"), "America/El_Salvador", gettext("El Salvador"));

    addCity(gettext("Fiji"), "Pacific/Fiji", gettext("Fiji"));
    addCity(gettext("Fortaleza"), "America/Fortaleza", gettext("Brazil"));
    addCity(gettext("Frankfurt"), "Europe/Berlin", gettext("Germany"));
    addCity(gettext("Freetown"), "Africa/Freetown", gettext("Sierra Leone"));

    addCity(gettext("Gaborone"), "Africa/Gaborone", gettext("Botswana"));
    addCity(gettext("Gaza"), "Asia/Gaza", gettext("Palestine"));
    addCity(gettext("Gibraltar"), "Europe/Gibraltar", gettext("Gibraltar"));
    addCity(gettext("Grand Turk"), "America/Grand_Turk", gettext("Turks and Caicos Islands"));
    addCity(gettext("Grenada"), "America/Grenada", gettext("Grenada"));
    addCity(gettext("Guam"), "Pacific/Guam", gettext("Guam"));
    addCity(gettext("Guangzhou"), "Asia/Shanghai", gettext("China"));
    addCity(gettext("Guatemala"), "America/Guatemala", gettext("Guatemala"));
    addCity(gettext("Gurgaon"), "Asia/Kolkata", gettext("India"));
    addCity(gettext("Guyana"), "America/Guyana", gettext("Guyana"));

    addCity(gettext("Haifa"), "Asia/Jerusalem", gettext("Israel"));
    addCity(gettext("Halifax"), "America/Halifax", gettext("Canada"));
    addCity(gettext("Hamburg"), "Europe/Berlin", gettext("Germany"));
    addCity(gettext("Hanoi"), "Asia/Ho_Chi_Minh", gettext("Vietnam"));
    addCity(gettext("Harare"), "Africa/Harare", gettext("Zimbabwe"));
    addCity(gettext("Havana"), "America/Havana", gettext("Cuba"));
    addCity(gettext("Hebron"), "Asia/Hebron", gettext("Palestine"));
    addCity(gettext("Helsinki"), "Europe/Helsinki", gettext("Finland"));
    addCity(gettext("Ho Chi Minh City"), "Asia/Ho_Chi_Minh", gettext("Vietnam"));
    addCity(gettext("Hong Kong"), "Asia/Hong_Kong", gettext("Hong Kong"));
    addCity(gettext("Honolulu"), "Pacific/Honolulu", gettext("United States"));
    addCity(gettext("Houston"), "America/Chicago", gettext("United States"));
    addCity(gettext("Hyderabad"), "Asia/Kolkata", gettext("India"));

    addCity(gettext("Indianapolis"), "America/Indiana/Indianapolis", gettext("United States"));
    addCity(gettext("Islamabad"), "Asia/Karachi", gettext("Pakistan"));
    addCity(gettext("Isle of Man"), "Europe/Isle_of_Man", gettext("Isle of Man"));
    addCity(gettext("Istanbul"), "Europe/Istanbul", gettext("Turkey"));

    addCity(gettext("Jacksonville"), "America/New_York", gettext("United States"));
    addCity(gettext("Jakarta"), "Asia/Jakarta", gettext("Indonesia"));
    addCity(gettext("Jerusalem"), "Asia/Jerusalem", gettext("Israel"));
    addCity(gettext("Johannesburg"), "Africa/Johannesburg", gettext("South Africa"));

    addCity(gettext("Kabul"), "Asia/Kabul", gettext("Afghanistan"));
    addCity(gettext("Kampala"), "Africa/Kampala", gettext("Uganda"));
    addCity(gettext("Karachi"), "Asia/Karachi", gettext("Pakistan"));
    addCity(gettext("Khartoum"), "Africa/Khartoum", gettext("Sudan"));
    addCity(gettext("Kiev"), "Europe/Kiev", gettext("Ukraine"));
    addCity(gettext("Kigali"), "Africa/Kigali", gettext("Rwanda"));
    addCity(gettext("Kingston"), "America/Toronto", gettext("Canada"));
    addCity(gettext("Kinshasa"), "Africa/Kinshasa", gettext("Democratic Republic of the Congo"));
    addCity(gettext("Kiritimati"), "Pacific/Kiritimati", gettext("Kiribati"));
    addCity(gettext("Kirkland"), "America/Montreal", gettext("Canada"));
    addCity(gettext("Knox"), "Australia/Melbourne", gettext("Australia"));
    addCity(gettext("Knoxville"), "America/New_York", gettext("United States"));
    addCity(gettext("Kraków"), "Europe/Warsaw", gettext("Poland"));
    addCity(gettext("Kuala Lumpur"), "Asia/Kuala_Lumpur", gettext("Malaysia"));
    addCity(gettext("Kuwait City"), "Asia/Kuwait", gettext("Kuwait"));
    addCity(gettext("Kyiv"), "Europe/Kiev", gettext("Ukraine"));

    addCity(gettext("Lagos"), "Africa/Lagos", gettext("Nigeria"));
    addCity(gettext("Lahore"), "Asia/Karachi", gettext("Pakistan"));
    addCity(gettext("Las Vegas"), "America/Los_Angeles", gettext("United States"));
    addCity(gettext("Lima"), "America/Lima", gettext("Peru"));
    addCity(gettext("Lisbon"), "Europe/Lisbon", gettext("Portugal"));
    addCity(gettext("London"), "Europe/London", gettext("United Kingdom"));
    addCity(gettext("Longyearbyen"), "Arctic/Longyearbyen", gettext("Svalbard and Jan Mayen"));
    addCity(gettext("Los Angeles"), "America/Los_Angeles", gettext("United States"));
    addCity(gettext("Louisville"), "America/Kentucky/Louisville", gettext("United States"));
    addCity(gettext("Luxembourg"), "Europe/Luxembourg", gettext("Luxembourg"));

    addCity(gettext("Macau"), "Asia/Macau", gettext("Macao"));
    addCity(gettext("Madison"), "America/Chicago", gettext("United States"));
    addCity(gettext("Madrid"), "Europe/Madrid", gettext("Spain"));
    addCity(gettext("Maldives"), "Indian/Maldives", gettext("Maldives"));
    addCity(gettext("Malta"), "Europe/Malta", gettext("Malta"));
    addCity(gettext("Managua"), "America/Managua", gettext("Nicaragua"));
    addCity(gettext("Manchester"), "Europe/London", gettext("United Kingdom"));
    addCity(gettext("Manila"), "Asia/Manila", gettext("Philippines"));
    addCity(gettext("Marengo"), "America/Indiana/Marengo", gettext("United States"));
    addCity(gettext("Martinique"), "America/Martinique", gettext("Canada"));
    addCity(gettext("Maseru"), "Africa/Maseru", gettext("Lesotho"));
    addCity(gettext("Melbourne"), "Australia/Melbourne", gettext("Australia"));
    addCity(gettext("Memphis"), "America/Chicago", gettext("United States"));
    addCity(gettext("Mendoza"), "America/Argentina/Mendoza", gettext("Argentina"));
    addCity(gettext("Metlakatla"), "America/Metlakatla", gettext("United States"));
    addCity(gettext("Mexico City"), "America/Mexico_City", gettext("Mexico"));
    addCity(gettext("Miami"), "America/New_York", gettext("United States"));
    addCity(gettext("Milan"), "Europe/Rome", gettext("Italy"));
    addCity(gettext("Milwaukee"), "America/Chicago", gettext("United States"));
    addCity(gettext("Minneapolis"), "America/Chicago", gettext("United States"));
    addCity(gettext("Minsk"), "Europe/Minsk", gettext("Belarus"));
    addCity(gettext("Mogadishu"), "Africa/Mogadishu", gettext("Somalia"));
    addCity(gettext("Monrovia"), "Africa/Monrovia", gettext("Liberia"));
    addCity(gettext("Monaco"), "Europe/Monaco", gettext("Monaco"));
    addCity(gettext("Monterrey"), "America/Monterrey", gettext("Mexico"));
    addCity(gettext("Montevideo"), "America/Montevideo", gettext("Uruguay"));
    addCity(gettext("Montreal"), "America/Montreal", gettext("Canada"));
    addCity(gettext("Moscow"), "Europe/Moscow", gettext("Russia"));
    addCity(gettext("Mountain View"), "America/Los_Angeles", gettext("United States"));
    addCity(gettext("Mumbai"), "Asia/Kolkata", gettext("India"));
    addCity(gettext("Munich"), "Europe/Berlin", gettext("Germany"));
    addCity(gettext("Muscat"), "Asia/Muscat", gettext("Oman"));

    addCity(gettext("Nairobi"), "Africa/Nairobi", gettext("Kenya"));
    addCity(gettext("Nashville"), "America/Chicago", gettext("United States"));
    addCity(gettext("Nassau"), "America/Nassau", gettext("Bahamas"));
    addCity(gettext("New Orleans"), "America/Chicago", gettext("United States"));
    addCity(gettext("New Salem"), "America/North_Dakota/New_Salem", gettext("United States"));
    addCity(gettext("New South Wales"), "Australia/Sydney", gettext("Australia"));
    addCity(gettext("New York"), "America/New_York", gettext("United States"));
    addCity(gettext("Newfoundland"), "America/St_Johns", gettext("United States"));
    addCity(gettext("Nouméa"), "Pacific/Noumea", gettext("New Caledonia"));
    addCity(gettext("Nuestra Señora de La Paz"), "America/Bogota", gettext("Colombia"));

    addCity(gettext("Oklahoma City"), "America/Chicago", gettext("United States"));
    addCity(gettext("Osaka"), "Asia/Tokyo", gettext("Japan"));
    addCity(gettext("Oslo"), "Europe/Oslo", gettext("Norway"));
    addCity(gettext("Ottawa"), "America/Toronto", gettext("Canada"));
    addCity(gettext("Oulu"), "Europe/Helsinki", gettext("Finland"));

    addCity(gettext("Panamá"), "America/Panama", gettext("Panama"));
    addCity(gettext("Paramaribo"), "America/Paramaribo", gettext("Suriname"));
    addCity(gettext("Paris"), "Europe/Paris", gettext("France"));
    addCity(gettext("Perth"), "Australia/Perth", gettext("Australia"));
    addCity(gettext("Petersburg"), "America/Indiana/Petersburg", gettext("Russia"));
    addCity(gettext("Philadelphia"), "America/New_York", gettext("United States"));
    addCity(gettext("Phnom Penh"), "Asia/Phnom_Penh", gettext("Cambodia"));
    addCity(gettext("Phoenix"), "America/Phoenix", gettext("United States"));
    addCity(gettext("Pittsburgh"), "America/New_York", gettext("United States"));
    addCity(gettext("Port of Spain"), "America/Port_of_Spain", gettext("Trinidad and Tobago"));
    addCity(gettext("Port au Prince"), "America/Port-au-Prince", gettext("Haiti"));
    addCity(gettext("Portland"), "America/Los_Angeles", gettext("United States"));
    addCity(gettext("Prague"), "Europe/Prague", gettext("Czech"));
    addCity(gettext("Pyongyang"), "Asia/Pyongyang", gettext("North Korea"));

    addCity(gettext("Queensland"), "Australia/Brisbane", gettext("United States"));
    addCity(gettext("Quito"), "America/Guayaquil", gettext("Ecuador"));

    addCity(gettext("Rangoon"), "Asia/Rangoon", gettext("Myanmar"));
    addCity(gettext("Reno"), "America/Los_Angeles", gettext("United States"));
    addCity(gettext("Reston"), "America/New_York", gettext("United States"));
    addCity(gettext("Reykjavík"), "Atlantic/Reykjavik", gettext("Iceland"));
    addCity(gettext("Riga"), "Europe/Riga", gettext("Latvia"));
    addCity(gettext("Rio de Janeiro"), "America/Sao_Paulo", gettext("Brazil"));
    addCity(gettext("Riyadh"), "Asia/Riyadh", gettext("Saudi Arabia"));
    addCity(gettext("Rome"), "Europe/Rome", gettext("Italy"));

    addCity(gettext("Sacramento"), "America/Los_Angeles", gettext("United States"));
    addCity(gettext("Salt Lake City"), "America/Denver", gettext("United States"));
    addCity(gettext("Samoa"), "Pacific/Apia", gettext("Samoa"));
    addCity(gettext("San Antonio"), "America/Chicago", gettext("United States"));
    addCity(gettext("San Diego"), "America/Los_Angeles", gettext("United States"));
    addCity(gettext("San Francisco"), "America/Costa_Rica", gettext("United States"));
    addCity(gettext("San José"), "America/Costa_Rica", gettext("Costa Rica"));
    addCity(gettext("San Juan"), "America/Puerto_Rico", gettext("Puerto Rico"));
    addCity(gettext("San Marino"), "Europe/San_Marino", gettext("San Marino"));
    addCity(gettext("San Salvador"), "America/El_Salvador", gettext("El Salvador"));
    addCity(gettext("Sanaa"), "Asia/Aden", gettext("Yemen"));
    addCity(gettext("Santiago"), "America/Santiago", gettext("Chile"));
    addCity(gettext("Santo Domingo"), "America/Santo_Domingo", gettext("Dominican Republic"));
    addCity(gettext("São Paulo"), "America/Sao_Paulo", gettext("Brazil"));
    addCity(gettext("São Tomé"), "Africa/Sao_Tome", gettext("São Tomé and Príncipe"));
    addCity(gettext("Sarajevo"), "Europe/Sarajevo", gettext("Bosnia and Herzegovina"));
    addCity(gettext("Saskatchewan"), "America/Regina", gettext("Canada"));
    addCity(gettext("Seattle"), "America/Los_Angeles", gettext("United States"));
    addCity(gettext("Seoul"), "Asia/Seoul", gettext("South Korea"));
    addCity(gettext("Shanghai"), "Asia/Shanghai", gettext("China"));
    addCity(gettext("Singapore"), "Asia/Singapore", gettext("Singapore"));
    addCity(gettext("Simferopol’"), "Europe/Simferopol", gettext("Ukraine"));
    addCity(gettext("Skopje"), "Europe/Skopje", gettext("Macedonia"));
    addCity(gettext("Sofia"), "Europe/Sofia", gettext("Bulgaria"));
    addCity(gettext("St.Johns"), "America/St_Johns", gettext("Canada"));
    addCity(gettext("St.Kitts"), "America/St_Kitts", gettext("Saint Kitts and Nevis"));
    addCity(gettext("St.Louis"), "America/Chicago", gettext("United States"));
    addCity(gettext("Stanley"), "Atlantic/Stanley", gettext("Falkland Islands"));
    addCity(gettext("Stockholm"), "Europe/Stockholm", gettext("Sweden"));
    addCity(gettext("Suva"), "Pacific/Fiji", gettext("Fiji"));
    addCity(gettext("Sydney"), "Australia/Sydney", gettext("Australia"));

    addCity(gettext("Taipei"), "Asia/Taipei", gettext("Taiwan"));
    addCity(gettext("Tallinn"), "Europe/Tallinn", gettext("Estonia"));
    addCity(gettext("Tehran"), "Asia/Tehran", gettext("Iran"));
    addCity(gettext("Tokyo"), "Asia/Tokyo", gettext("Japan"));
    addCity(gettext("Toronto"), "America/Toronto", gettext("Canada"));
    addCity(gettext("Tripoli"), "Africa/Tripoli", gettext("Libyra"));
    addCity(gettext("Tunis"), "Africa/Tunis", gettext("Tunisia"));

    addCity(gettext("Ulan Bator"), "Asia/Ulan_Bator", gettext("Mongolia"));
    addCity(gettext("UTC"), "UTC", gettext("UTC"));

    addCity(gettext("Vancouver"), "America/Vancouver", gettext("Canada"));
    addCity(gettext("Vatican City"), "Europe/Vatican", gettext("Vatican City"));
    addCity(gettext("Vevay"), "America/Indiana/Vevay", gettext("United States"));
    addCity(gettext("Vienna"), "Europe/Vienna", gettext("Austria"));
    addCity(gettext("Vilnius"), "Europe/Vilnius", gettext("Lithuania"));
    addCity(gettext("Vincennes"), "America/Indiana/Vincennes", gettext("France"));

    addCity(gettext("Warsaw"), "Europe/Warsaw", gettext("Poland"));
    addCity(gettext("Washington D.C"), "America/New_York", gettext("United States"));
    addCity(gettext("Winamac"), "America/Indiana/Winamac", gettext("United States"));
    addCity(gettext("Winnipeg"), "America/Winnipeg", gettext("Canada"));
    addCity(gettext("Wrocław"), "Europe/Warsaw", gettext("Poland"));

    addCity(gettext("Zagreb"), "Europe/Zagreb", gettext("Croatia"));
    addCity(gettext("Zürich"), "Europe/Zurich", gettext("Switzerland"));

    // Let QML know model is reusable again
    endResetModel();
}
