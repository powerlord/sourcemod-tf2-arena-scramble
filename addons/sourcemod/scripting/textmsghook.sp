/**
 * vim: set ts=4 :
 * =============================================================================
 * [TF2] Arena Scramble
 * Make tf_arena_use_queue scramble and score like normal arena
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
#pragma semicolon 1

// Enable this to turn on debugging code.
//#define DEBUG

#define VERSION "1.0.0"

public Plugin:myinfo = {
	name			= "Read TextMsg values",
	author			= "Powerlord",
	description		= "Read this to check what the TextMsg usermessage is sending back.",
	version			= VERSION,
	url				= ""
};

public OnPluginStart()
{
	HookUserMessage(GetUserMessageId("TextMsg"), Msg_TextMsg);
}

public Action:Msg_TextMsg(UserMsg:msg_id, Handle:msg, const players[], playersNum, bool:reliable, bool:init)
{
	new msg_dest;
	new String:msg_name[64];
	new String:param1[64];
	new String:param2[64];
	new String:param3[64];
	new String:param4[64];
	
	msg_dest = BfReadByte(msg);
	BfReadString(msg, msg_name, sizeof(msg_name));

	BfReadString(msg, param1, sizeof(param1));
	BfReadString(msg, param2, sizeof(param2));
	BfReadString(msg, param3, sizeof(param3));
	BfReadString(msg, param4, sizeof(param4));
	
	LogToFile("textmsg.txt", "TextMsg sent to %d players at %d: \"%s\" (\"%s\", \"%s\", \"%s\", \"%s\")", playersNum, msg_dest, msg_name, param1, param2, param3, param4);
}
