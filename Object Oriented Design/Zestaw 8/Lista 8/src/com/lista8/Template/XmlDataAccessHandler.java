package com.lista8.Template;

import org.w3c.dom.*;
import org.xml.sax.SAXException;

import javax.xml.parsers.*;
import java.io.*;
import java.util.ArrayList;


/**
 * Created by dziku on 11.05.16.
 */
public class XmlDataAccessHandler extends DataAccessHandler
{
    private String path;
    private Document document;

    private ArrayList<String> tags;
    private int maxlength;

    public XmlDataAccessHandler(String path)
    {
        this.path = path;
        tags = new ArrayList<>();
    }

    @Override
    protected void Connect()
    {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = null;
        try
        {
            builder = factory.newDocumentBuilder();
            document = builder.parse("ToParse.xml");
        }
        catch (SAXException e)
        {
            e.printStackTrace();
        }
        catch (ParserConfigurationException e)
        {
            e.printStackTrace();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    @Override
    protected void GetData()
    {
        VisitNode(document.getDocumentElement());
    }

    @Override
    protected void ProcessData()
    {
        maxlength = 0;
        String maxname = "";

        for (String name :
                tags)
        {
            if(maxlength < name.length())
            {
                maxlength = Math.max(maxlength, name.length());
                maxname = name;
            }
        }

        System.out.println("Max tag name in " + path + " is " + Integer.toString(maxlength) + " " + maxname);
    }

    @Override
    protected void CloseConnection()
    {
        //Chyba nic nie muszę robić
    }

    private void VisitNode(Node node)
    {
        tags.add(node.getNodeName());

        NodeList children = node.getChildNodes();
        for(int i=0;i<children.getLength();++i)
        {
            Node child = children.item(i);
            VisitNode(child);
        }
    }

    public int GetMaxTagLength()
    {
        return maxlength;
    }

}
