package com.darksoulsdeaths;

import org.apache.commons.fileupload.FileItem;

import java.io.ByteArrayInputStream;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

public class FileController
{
    private FileController(){}
    static
    {
        //
    }
    public static Map<String,Integer> getDeathsFromFile(FileItem file)
    {
        //OLD FORMAT: filesize ~4226kb
            //charnames start at 0x3c0/959 and are spaced 0x60190/393616 bytes apart
            //death count is 0x1F028/127016 bytes after the start of the character name
        //NEW FORMAT: filesize ~4229kb
            //charnames start at 0x3c0 and are spaced 0x60020/393248 bytes apart
            //death count is 0x1F028/127016 bytes after the start of the character name

        Map<String,Integer> data = new HashMap<>();

        byte[] raw = file.get();

        boolean oldFormat = (raw.length == 4330480);

        ByteArrayInputStream stream = new ByteArrayInputStream(raw);

        stream.reset();
        stream.skip(959);
        for(int i=0; i<10; i++)
        {
            //mark the beginning of the slot, since all variables for the slot are measured relative to this location
            stream.mark(0);

            //get the character name and convert it to a string
            byte[] nameBytes = new byte[32];
            stream.read(nameBytes, 0, 32);
            String name = new String(nameBytes, StandardCharsets.UTF_16);
            if(name.charAt(0) == '\00') //indicates no valid character in this slot
            {
                continue; //theoretically we could just break here, but sometimes DS likes to stick blank character slots between valid ones
            }
            name = name.substring(0, name.indexOf('\00')); //truncate any junk after the name itself (separated by a null char)

            //go back to the slot marker and then skip ahead to where our death variable is
            stream.reset();
            //stream.skip(127016); //TODO:this is the value we measured in the save file, but it's off by 2 bytes
            stream.skip(127014); //works, but we don't know why
            byte[] deathBytes = new byte[4];
            stream.read(deathBytes, 0, 4);
            int deaths = ByteBuffer.wrap(deathBytes).getInt();
            System.out.println("Deaths: " + deaths);

            //save our info for this slot
            data.put(name, deaths);

            //move ahead to the next slot
            //TODO:check for EoF?
            stream.reset();
            if(oldFormat)
            {
                stream.skip(393616);
            }
            else
            {
                stream.skip(393248);
            }
        }
        return data; //TODO:why is this displaying out of order?
    }
}
