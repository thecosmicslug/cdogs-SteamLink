/*
    C-Dogs SDL
    A port of the legendary (and fun) action/arcade cdogs.

    Copyright (c) 2013, Cong Xu
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/
#include "config.h"

#include "blit.h"
#include "gamedata.h"
#include "grafx_bg.h"
#include "pic_manager.h"


int ConfigApply(Config *config)
{
	if (memcmp(&config->Sound, &gLastConfig.Sound, sizeof config->Sound) != 0)
	{
		SoundReconfigure(&gSoundDevice, &config->Sound);
	}
	if (memcmp(
		&config->Graphics, &gLastConfig.Graphics, sizeof config->Graphics) != 0)
	{
		gCampaign.seed = config->Game.RandomSeed;
		GraphicsInitialize(
			&gGraphicsDevice, &config->Graphics, gPicManager.palette, 0);
		GrafxMakeRandomBackground(
			&gGraphicsDevice, &gCampaign, &gMission, &gMap);
	}
	return gGraphicsDevice.IsInitialized;
}