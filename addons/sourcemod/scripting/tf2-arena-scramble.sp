/**
 * vim: set ts=4 :
 * =============================================================================
 * Name
 * Description
 *
 * Name (C)2014 Powerlord (Ross Bemrose).  All rights reserved.
 * =============================================================================
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * As a special exception, AlliedModders LLC gives you permission to link the
 * code of this program (as well as its derivative works) to "Half-Life 2," the
 * "Source Engine," the "SourcePawn JIT," and any Game MODs that run on software
 * by the Valve Corporation.  You must obey the GNU General Public License in
 * all respects for all other code used.  Additionally, AlliedModders LLC grants
 * this exception to all derivative works.  AlliedModders LLC defines further
 * exceptions, found in LICENSE.txt (as of this writing, version JULY-31-2007),
 * or <http://www.sourcemod.net/license.php>.
 *
 * Version: $Id$
 */
#include <sourcemod>
#include <sdktools>
#pragma semicolon 1

#define VERSION "1.0.0"

//swiped from tf2_morestocks.inc in my sourcemod-snippets repo
enum TF2GameType
{
	TF2GameType_Generic,
	TF2GameType_CTF = 1,
	TF2GameType_CP = 2,
	TF2GameType_PL = 3,
	TF2GameType_Arena = 4,
}

const REDScore = 0;
const BLUScore = 1;

// Valve CVars
new Handle:g_Cvar_Queue;

new bool:g_bActive = true;
new bool:g_bMapActive = false;

new Handle:g_Call_SetScramble;
new Handle:g_Call_ShouldScramble;

new TF2GameType:g_MapType = TF2GameType_Generic;

public Plugin:myinfo = {
	name			= "[TF2] Arena Scramble",
	author			= "Powerlord",
	description		= "",
	version			= VERSION,
	url				= ""
};

new g_Scores[2];

//swiped from tf2_morestocks.inc in my sourcemod-snippets repo
/**
 * What basic game type are we?
 *
 * Note that types are based on their base scoring type:
 * CTF - CTF, SD, MvM, and RD(?)
 * CP - CP, 5CP, and TC
 * PL - PL and PLR
 * Arena - Arena
 * 
 * You can find some of the specific types using the IsGameModeX functions.
 * You can tell if a CTF or CP also implements the opposite type using TF2_IsGameModeHybrid()
 * 
 * @return 	A TF2GameType value. 
 */
stock TF2GameType:TF2_GetGameType()
{
	return TF2GameType:GameRules_GetProp("m_nGameType");
}

public OnPluginStart()
{
	CreateConVar("tf2_arena_scramble_version", VERSION, "[TF2] Arena Scramble version", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_DONTRECORD|FCVAR_SPONLY);
	
	g_Cvar_Queue = FindConVar("tf_arena_use_queue");
	HookConVarChange(g_Cvar_Queue, Cvar_QueueState);
	
	HookEventEx("teamplay_round_win", Event_RoundEnd);
	
	new Handle:gamedata = LoadGameConfigFile("tf2scramble");
	
	if (gamedata == INVALID_HANDLE)
	{
		SetFailState("Could not load gamedata");
	}
	
	//void CTeamplayRules::SetScrambleTeams( bool bScramble )
	StartPrepSDKCall(SDKCall_GameRules);
	PrepSDKCall_SetFromConf(gamedata, SDKConf_Virtual, "CTeamplayRules::SetScrambleTeams");
	PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
	g_Call_SetScramble = EndPrepSDKCall();
	
	CloseHandle(gamedata);	
}

//void CTeamplayRules::SetScrambleTeams( bool bScramble )
stock SetScrambleTeams(bool:bScramble)
{
	g_bScramblePending = true;
	SDKCall(g_Call_SetScramble, bScramble);
}

public OnConfigsExecuted()
{
	g_bMapActive = true;
	g_bActive = false;
	
	g_MapType = TF2_GetGameType();
	
	// If queue is false, we need to be active
	if (!GetConVarBool(g_Cvar_Queue))
	{
		g_bActive = true;
	}
}

public OnMapEnd()
{
	g_MapType = TF2GameType_Generic;
}

public Event_RoundEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	
}

public Cvar_QueueState(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (g_MapType != TF2GameType_Arena)
	{
		return;
	}
	
	if (TF2_GetGameType() != TF2GameType_Arena)
	{
		return;
	}
	
	if (GetConVarInt(convar))
	{
	}
	else
	{
	}
}
