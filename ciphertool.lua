#!/usr/bin/env lua
function resetvars()
mode = ""
cipher = ""
text = ""
convertedtext = ""
alphabet = ("abcdefghijklmnopqrstuvwxyz") -- do not ever change this one, i need a traditional alphabet to refer off
cipherbet = alphabet -- for modification based on the algoritm based off the cipher
end 
function query(question)
answer = ""
while answer == "" do
  os.execute("clear")
  io.write("Cipher Tool v2.1 [Mode:"..(string.upper(mode:sub(1,1))..(mode:sub(2,string.len(mode)))).."] [Cipher:"..cipher.."]\n\n"..question.."\n\n") -- Polyalphabetic Substitution Cipher
  answer = io.read()
end
return answer
end

function createcipher() -- remove the crap from the cipher and build an alphabet called cipherbet based off the new, compatible cipher
  i = string.len(cipher)
  while i ~= 0 do
  if string.find(alphabet,cipher:sub(i,i)) == nil or cipher:sub(i,i) == " " or cipher:sub(i,i) == "." then cipher = (cipher:sub(1,i-1)..cipher:sub(i+1,string.len(cipher))) i = i + 1 end
  i = i - 1
  end
  cipher = string.lower(cipher) -- now we need to generate the new alphabet (cipherbet)
  i = string.len(cipher)
  while i ~= 0 do
  cipherletter = cipher:sub(i,i)
  ciphernumber = string.find(cipherbet,cipherletter) -- this returns it's numerical position on the cipherbet, now we need to remove it from cipherbet and reposition it to the front of it
  cipherbet = (cipherbet:sub(1,ciphernumber-1)..(cipherbet:sub(ciphernumber+1,string.len(cipherbet))))
  cipherbet = (cipherletter..cipherbet)
  i = i - 1
  end
end

function mainmenu()
  resetvars()
  answer = query("Encrypt or Decrypt?")
  answer = string.lower(answer:sub(1,1)) --shorten & lowercase it
  if answer == "e" then mode = "encrypt" getdata()
  elseif answer == "d" then mode = "decrypt" getdata()
  end
  mainmenu() -- once decrypt and encrypt finishes, or answer ~= e or d it'l bring it back to the main menu
end

function getdata() -- this gets the encryption key and the string, then calls encrypt or decrypt based on the mode variable; as well as also handling the cipherbet creation
  cipher = string.lower(query("Cipher to apply during "..mode.."ion:"))
  createcipher()
  text = string.lower(query("Text to "..mode..":"))
  reverse = string.lower(query("Reverse the resultant text? (y/n)")) -- default is no
  reverse = reverse:sub(1,1)
  if mode == "encrypt" or mode == "decrypt" then converttext() end
end

function converttext() 
  if mode == "decrypt" then local alphabet2 = alphabet alphabet = cipherbet cipherbet = alphabet2 end           --we need to find the letter for changing, then find its number spot on the alphabet then use that number on the cipherbet to get the letter which-
  while string.len(text) ~= 0 do -- we will finally add to the new string called convertedtext
  local lettertochange = text:sub(1,1) -- returns the first letter on the text string (which we need to convert)
  local alphabetpos = string.find(alphabet,lettertochange) -- returns where lettertochange is on a normal alphabet
  if alphabetpos ~= nil then newletter = cipherbet:sub(alphabetpos,alphabetpos) else newletter = " " end -- returns letter equivalent from cypherbet of alphabet's
  if reverse == "y" then convertedtext = (newletter..convertedtext) else convertedtext = (convertedtext..newletter) end -- 
  text = text:sub(2,string.len(text)) -- remove the first letter which we have converted
  end
  query("Converted text:\n\n"..convertedtext) -- to prevent accidental presses this waits for at least one character before pressing enter
  mainmenu()
end

mainmenu()