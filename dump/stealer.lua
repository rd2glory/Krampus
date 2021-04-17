local Classes; -- Author @Rerumu <3
local Props			= {}; --Edited by Doctor Derank to work
local Concat		= table.concat; -- Concatenation is going to get reworked just a couple times maybe?
local tostring		= tostring;
local Players		= game:GetService('Players');
local Beat			= game:GetService('RunService').Heartbeat;

-- Changelog
--[[
	* Whatever version this is
		-- Did some concatenation changes
		-- Also some other minor performance upgrades
		--- Synapse and Elysian individual support
		---- Re-did Elysian callback stuff because it was slow
		---- Added an Elysian fallback to LuaDec whenever needed
]]

local InNil;
local Print;
local WritesFl;
local Decompile;

local NotFilter	= (not workspace.FilteringEnabled); -- Bytecode used to replicate lol
local SaveList	= {
	game:GetService('Workspace');
	game:GetService('ReplicatedFirst');
	game:GetService('ReplicatedStorage');
	game:GetService('ServerStorage'); -- Internal stuff
	game:GetService('Lighting');
	game:GetService('StarterGui');
	game:GetService('StarterPack');
	game:GetService('StarterPlayer');
	game:GetService('Teams');
	game:GetService('InsertService');
};

local IgnoredList	= {
	'CameraScript';
	'ControlScript';
	'ChatScript';
	'Camera';
}

local NoNoProp	= {
	Instance	= {
		Archivable		= true,
		DataCost		= true,
		ClassName		= true,
		RobloxLocked	= true,
		Parent			= true
	};
	BasePart	= {
		Position	= true,
		Rotation	= true
	};
};

for Idx = 1, 3 do
	local Ran, Err	= ypcall(function()
		Classes	= game:HttpGetAsync('http://anaminus.github.io/rbx/json/api/latest.json');
--		Classes	= game:GetService('HttpService'):GetAsync('http://anaminus.github.io/rbx/json/api/latest.json');
	end);

	if (not Ran) then
		if (Idx == 3) then
			error(Err, 0);
		else
			wait(1);
		end;
	else -- Setup stuff
		local Me		= Players.LocalPlayer;

		for _, Player in next, Players:GetPlayers() do
			if (Player ~= Me) then
				table.insert(IgnoredList, tostring(Player)); -- Let's *not*
			end;
		end;

		local NumIg	= #IgnoredList;

		Classes	= game:GetService('HttpService'):JSONDecode(Classes);

		for Idx = 1, NumIg do
			IgnoredList[IgnoredList[Idx]]	= true;
			IgnoredList[Idx]	= nil;
		end;

		break;
	end;
end;

if syn then -- Oh my god 3ds why couldn't you just use '.' syntax
	function InNil()
		return getnilinstances()
	end;

	function WritesFl(Location, Data)
		return writefile(Location, Data)
	end;

	function Decompile(Script)
		return '--decompiler is slow, removed right now :('
	end;

	Print = warn;

	Print('ReruSavePlace detected Synapse, functions loaded');
else
	error('This exploit may not be supported by RSP, please contact me');
end;

do
	local Temp	= {};

	for Idx, Val in next, Classes do
		if (Val.type == 'Class') then
			Temp[Val.Name]	= Val;
			Temp[Val.Name].Properties	= {};
		elseif (Val.type == 'Property') then
			local Ignore;

			for _, Tag in next, Val.tags do
				if (Tag == 'deprecated') or (Tag == 'hidden') or (Tag == 'readonly') then
					Ignore	= true;

					break;
				end;
			end;

			if (not Ignore) then
				local Ignored	= NoNoProp[Val.Class];

				if Ignored and Ignored[Val.Name] then
					Ignore	= true;
				end;

				if (not Ignore) then
					local Props	= Temp[Val.Class].Properties;

					Props[#Props + 1]	= Val;
				end;
			end;
		end;
	end;

	Classes	= Temp;
end;

local function PropsOf(Obj)
	if Props[Obj.ClassName] then
		return Props[Obj.ClassName];
	end;

	local Prop	= {};
	local Class	= Obj.ClassName;

	while Class do
		local Curr	= Classes[Class];

		for Index, Value in next, Curr.Properties do
			Prop[#Prop + 1]	= Value;
		end;

		Class = Curr.Superclass;
	end;

	table.sort(Prop, function(A, B)
		return A.Name < B.Name;
	end);

	Props[Obj.ClassName] = Prop;

	return Prop;
end;

local function SetParent(Obj, Parent)
	local Arch = Obj.Archivable;
	local Cloned;

	Obj.Archivable = true;
	Cloned = Obj:Clone();

	if (not Cloned) then
		local pcall = pcall;

		Cloned = Instance.new'Folder'

		for Index, Child in next, Obj:GetChildren() do
			pcall(SetParent, Child, Cloned);
		end;

		Cloned.Name		= Obj.Name .. ':' .. Obj.ClassName;
	end;

	Obj.Archivable	= Arch;
	Cloned.Parent	= Parent;
end;

local function SavePlaceAsync()
	local Count	= 0;
	local Final	= {};
	local Timer	= tick();
	local Saved	= setmetatable({}, {__index = function(This, Idx) local C = Count + 1; Count = C; This[Idx] = C; return C; end});

	local pcall	= pcall; -- Skid syndrome

	Final[1]	= '<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4"><External>null</External><External>nil</External>';
	Print('Saving place...');

	local function SaveInstance(Obj)
		if Classes[Obj.ClassName] and (not IgnoredList[Obj.Name]) then
			local Props	= PropsOf(Obj);
			local Num	= Saved[Obj];
			local Conversions	= {
				['&']	= '&amp;';
				['<']	= '&lt;';
				['>']	= '&gt;';
			}

			Final[#Final + 1]	= '<Item class="' .. Obj.ClassName .. '" referent="RBX' .. Num .. '"><Properties>';

			if Num % 100 == 0 then
				Print('Reached ' .. Num .. ' instances saved');

				Beat:wait();
				Beat:wait();
			end

			for _, Prop in next, Props do
				local Append;
				local Type = Prop.ValueType;
				local ObjProp = Prop.Name;
				if ObjProp ~= "TemporaryLegacyPhysicsSolverOverride" then
				local Objp = Obj[ObjProp];

				if (typeof(Objp) == 'EnumItem') then
					Append	= '<token name="' .. ObjProp .. '">' .. Objp.Value .. '</token>';
				else
					if (Type == 'bool') then
						Append	= '<bool name="' .. ObjProp .. '">' .. tostring(Objp) .. '</bool>';
					elseif (Type == 'float') then
						Append = '<float name="' .. ObjProp .. '">' .. tostring(Objp) .. '</float>';
					elseif (Type == 'int') then
						Append = '<int name="' .. ObjProp .. '">' .. tostring(Objp) .. '</int>';
					elseif (Type == 'double') then
						Append = '<float name="' .. ObjProp .. '">' .. tostring(Objp) .. '</float>';
					elseif (Type == 'string') then
						local String = Objp:gsub("[&<>]", Conversions); -- Because I got C O M P L A I N T S

						Append = '<string name="' .. ObjProp .. '">' .. String .. '</string>';
					elseif (Type == 'BrickColor') then
						Append = '<int name="' .. ObjProp .. '">' .. Objp.Number .. '</int>';
					elseif (Type == 'Vector2') then
						Append =
							'<Vector2 name="' .. ObjProp .. '">'
						.. '<X>' .. Objp.x .. '</X>'
						.. '<Y>' .. Objp.y .. '</Y>'
						.. '</Vector2>'
					elseif (Type == 'Vector3') then
						Append =
							'<Vector3 name="' .. ObjProp .. '">'
						.. '<X>' .. Objp.x .. '</X>'
						.. '<Y>' .. Objp.y .. '</Y>'
						.. '<Z>' .. Objp.z .. '</Z>'
						.. '</Vector3>'
					elseif (Type == 'CoordinateFrame') then
						local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = Objp:components()

						Append =
							'<CoordinateFrame name="' .. ObjProp .. '">'
						.. '<X>' .. X .. '</X>'
						.. '<Y>' .. Y .. '</Y>'
						.. '<Z>' .. Z .. '</Z>'
						.. '<R00>' .. R00 .. '</R00>'
						.. '<R01>' .. R01 .. '</R01>'
						.. '<R02>' .. R02 .. '</R02>'
						.. '<R10>' .. R10 .. '</R10>'
						.. '<R11>' .. R11 .. '</R11>'
						.. '<R12>' .. R12 .. '</R12>'
						.. '<R20>' .. R20 .. '</R20>'
						.. '<R21>' .. R21 .. '</R21>'
						.. '<R22>' .. R22 .. '</R22>'
						.. '</CoordinateFrame>'
					elseif (Type == 'Content') then
						local String = Objp:gsub("[&<>]", Conversions);

						Append = '<Content name="' .. ObjProp .. '"><url>' .. String .. '</url></Content>';
					elseif (Type == 'UDim2') then
						local Objp	= Objp;

						Append =
							'<UDim2 name="' .. ObjProp .. '">'
						.. '<XS>' .. Objp.X.Scale .. '</XS>'
						.. '<XO>' .. Objp.X.Offset .. '</XO>'
						.. '<YS>' .. Objp.Y.Scale .. '</YS>'
						.. '<YO>' .. Objp.Y.Offset .. '</YO>'
						.. '</UDim2>'
					elseif (Type == 'Color3') then
						Append =
							'<Color3 name="' .. ObjProp .. '">'
						.. '<R>' .. Objp.r .. '</R>'
						.. '<G>' .. Objp.g .. '</G>'
						.. '<B>' .. Objp.b .. '</B>'
						.. '</Color3>'
					elseif (Type == 'NumberRange') then
						Append =
							'<NumberRange name="' .. ObjProp .. '">'
						.. tostring(Objp.Min)
						.. ' '
						.. tostring(Objp.Max)
						.. '</NumberRange>'
					elseif (Type == 'NumberSequence') then
						local Ob	= {};

						Ob[1]	= '<NumberSequence name="' .. ObjProp .. '">'

						for i, v in next, Objp.Keypoints do
							Ob[#Ob + 1]	= tostring(v.Time) .. ' ' .. tostring(v.Value) .. ' ' .. tostring(v.Envelope) .. ' ';
						end

						Ob[#Ob + 1]	= '</NumberSequence>';

						Append = Concat(Ob);
					elseif (Type == 'ColorSequence') then
						local Ob	= {};

						Ob[1]	= '<ColorSequence name="' .. ObjProp .. '">'

						for i, v in next, Objp.Keypoints do
							Ob[#Ob + 1]	= Concat{tostring(v.Time) .. ' ' .. tostring(v.Value.r) .. ' ' .. tostring(v.Value.g) .. ' ' .. tostring(v.Value.b), " 0 "};
						end

						Ob[#Ob + 1]	= '</ColorSequence>';

						Append = Concat(Ob);
					elseif (Type == 'Rect2D') then
						Append =
							'<Rect2D name="' .. ObjProp .. '">'
						.. '<min>'
						.. '<X>' .. tostring(Objp.Min.X) .. '</X>'
						.. '<Y>' .. tostring(Objp.Min.Y) .. '</Y>'
						.. '</min>'
						.. '<max>'
						.. '<X>' .. tostring(Objp.Max.X) .. '</X>'
						.. '<Y>' .. tostring(Objp.Max.Y) .. '</Y>'
						.. '</max>'
						.. '</Rect2D>'
					elseif (Type == 'ProtectedString') then
						local Src;

						if (ObjProp == 'Source') then
							if (Obj.ClassName ~= 'Script') or NotFilter then
								local Sc, Er	= Decompile(Obj);

								if (not Sc) then
									Src	= '--[[\n\t' .. Er .. '\n--]]';
								else
									Src	= Sc;
								end;
							else
								Src	= '-- Server script not decompiled :(';
							end;
						else
							Src = '';
						end;

						Append = '<ProtectedString name="' .. ObjProp .. '"><![CDATA[' .. Src .. ']]></ProtectedString>';
					elseif (Type == 'Object') then
						if (not Objp) then
							Objp	= 'null';
						else
							Objp	= 'RBX' .. Saved[Objp];
						end;

						Append = '<Ref name="' .. ObjProp .. '">' .. Objp .. '</Ref>';
					elseif (Type == 'PhysicalProperties') then
						if Objp then
							Append =
								'<PhysicalProperties name="' .. ObjProp .. '"><CustomPhysics>true</CustomPhysics>'
							.. '<Density>' .. tostring(Objp.Density) .. '</Density>'
							.. '<Friction>' .. tostring(Objp.Friction) .. '</Friction>'
							.. '<Elasticity>' .. tostring(Objp.Elasticity) .. '</Elasticity>'
							.. '<FrictionWeight>' .. tostring(Objp.FrictionWeight) .. '</FrictionWeight>'
							.. '<ElasticityWeight>' .. tostring(Objp.ElasticityWeight) .. '</ElasticityWeight>'
							.. '</PhysicalProperties>'
						else
							Append = '<PhysicalProperties name="' .. ObjProp .. '"><CustomPhysics>false</CustomPhysics></PhysicalProperties>';
						end;
					end;
				end;

				if Append then
					Final[#Final + 1]	= Append;
				end;
				end;
			end

			Final[#Final + 1]	= '</Properties>';

			for _, Obj in next, Obj:GetChildren() do
				SaveInstance(Obj);
			end;

			Final[#Final + 1]	= '</Item>';
		end;
	end;

	do
		local Real	= Players.LocalPlayer;
		local Serv	= game:GetService('ServerStorage');
		local Play	= Instance.new'Folder';

		Play.Parent			= Serv;
		Play.Name			= 'LocalPlayer';

		for _, Des in next, Real:GetChildren() do
			pcall(SetParent, Des, Play);
		end;

		if InNil then
			local Extr	= Instance.new'Folder';

			Extr.Parent			= Serv;
			Extr.Name			= 'Nil_Instances';

			for _, Nil in next, InNil() do
				pcall(SetParent, Nil, Extr);
			end;
		end;
	end;

	for _, Child in next, SaveList do
		SaveInstance(Child);
	end;

	Final[#Final + 1]	= '</roblox>';

	local Place	= game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId);

	if Place.Name then
		local Illegal	= {'/', '\\', ':', '?', '"', '\'', '<', '>', '|'};

		for Idx	= 1, #Illegal do
			Illegal[Illegal[Idx]]	= '';

			Illegal[Idx]	= nil;
		end;

		Place	= string.gsub(Place.Name, '.', Illegal);
	else
		Place	= 'Unknown';
	end;

	Print('Done serializing, writing to file');

	wait(5)

	WritesFl(Place .. '.rbxlx', Concat(Final));

	Print(string.format('Saving took %d second(s), please check your workspace folder', tick() - Timer));
end;

SavePlaceAsync();
