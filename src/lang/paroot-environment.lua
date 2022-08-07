--[[
**Free Software licensed under BSD (2-clause) license**


Copyright 2021 Gabriel Margarido

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

]]





-- This library can detect the current operating system,
-- and current CPU architecture.

----------- **************************** -----------

-- @returns:    "Windows"   ->      Windows Vista, Windows 7, Windows 8,
--                                  Windows 8.1, Windows 10, Windows 11.

--              "Unix"      ->      Apple macOS, GNU/Linux, GNU/Hurd,
--                                  FreeBSD, OpenBSD, NetBSD, TrueOS,
--                                  GhostBSD, Minix, etc..

----------- **************************** -----------

-- *DETECT OPERATING SYSTEM?
--      require('paroot-environment')
--
--      local myOS = getEnvironmentOS()
--      if myOS == 'Unix' then
--               ...
--      end
--
--      if myOS == 'Windows' then
--               ...
--      end

----------- **************************** -----------


----------- **************************** -----------
--
-- *DETECT CPU ARCHITECTURE?
--      <ARCH> =
--          'x86_64',       ->      64-bit
--          'powerpc',      ->      IBM PowerPC
--          'arm',          ->      ARM
--          'mips',         ->      MIPS
--          'x86',          ->      32-bit
--          'undefined'     ->      Unrecognizable architecture
--
----------- **************************** -----------

--      require('paroot-environment')
--
--      local myCPU = getEnvironmentArch()
--      if myCPU == <ARCH> then
--              ...
--      end

----------- **************************** -----------

-- @example:
--      if myCPU == 'x86_64' then
--                ...
--      end

----------- **************************** -----------


function getEnvironmentArch()
    if os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'amd64'
    or os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'x86_64'
    or os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'x64' then
        -- Intel: 64-bit / 64-bit (with 32-bit compatibility)
        return 'x86_64'

    elseif os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'powerpc' then
        -- IBM PowerPC
        return 'powerpc'

    elseif os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'arm' then
        -- ARM 32-bit/64-bit (M1, A4, A12Z Bionic, Snapdragon, etc..)
        return 'arm'

    elseif os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'mips' then
        return 'mips'

    elseif os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'ia32'
    or os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'x86'
    or os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'i386'
    or os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'i486'
    or os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'i586'
    or os.getenv('PROCESSOR_ARCHITECTURE'):lower() == 'i686' then
        -- Intel 32-bit (without 64-bit compatibility)
        return 'x86'

    elseif os.getenv('PROCESSOR_ARCHITECTURE'):lower() == nil then
        -- Unrecognizable CPU architecture
        return 'undefined'
    else
        -- Unrecognizable CPU architecutre
        return 'undefined'
    end

end

function getEnvironmentOS()
    if package.config:sub(1,1) == '\\' then
        return 'Windows'
    elseif package.config:sub(1,1) == '/' then
        return 'Unix'
    end
end