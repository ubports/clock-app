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

#include <QDir>
#include <QFileInfo>
#include <QStandardPaths>

#include "sound.h"

Sound::Sound(QObject *parent):
    QObject(parent),
    m_customAlarmDir(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first() + "/CustomSounds/"),
    m_defaultAlarmDir("/usr/share/sounds/ubuntu/ringtones/")
{
}

QString Sound::customAlarmSoundDirectory() const
{
    return m_customAlarmDir;
}

void Sound::deleteCustomAlarmSound(const QString &soundName)
{
    QDir dir(m_customAlarmDir);
    if (dir.exists(soundName))
    {
        dir.remove(soundName);
    }
}

void Sound::prepareToAddAlarmSound(const QString &soundPath)
{
    QFileInfo soundFile(soundPath);
    QString soundFileName = soundFile.fileName();
    deleteCustomAlarmSound(soundFileName);
}

void Sound::createCustomAlarmSoundDirectory()
{
    QDir dir(m_customAlarmDir);

    if (dir.exists())
    {
        return;
    }

    dir.mkpath(m_customAlarmDir);
}

bool Sound::isAlarmSoundValid(const QString &soundFileName)
{
    QFileInfo soundFile;

    if (soundFile.exists(m_defaultAlarmDir + soundFileName))
    {
        return true;
    }

    else if (soundFile.exists(m_customAlarmDir + soundFileName))
    {
        return true;
    }

    else
    {
        return false;
    }
}

bool Sound::isAlarmSoundValid(const QUrl &soundUrl)
{
    QFileInfo soundFile;
    return soundFile.exists(soundUrl.path());
}

QString Sound::getDefaultAlarmSoundPath(const QString &soundFileName) const
{
    return m_defaultAlarmDir + soundFileName;
}

QString Sound::getSoundName(const QString &soundPath) const
{
    QFileInfo soundFile(soundPath);
    return soundFile.baseName();
}
