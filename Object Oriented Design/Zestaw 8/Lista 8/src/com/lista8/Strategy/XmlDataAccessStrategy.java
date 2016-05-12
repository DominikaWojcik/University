package com.lista8.Strategy;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Created by dziku on 11.05.16.
 */
public class XmlDataAccessStrategy implements IDataAccessStrategy
{
    private String path;
    private Document document;

    private ArrayList<String> tags;
    private int maxlength;

    public XmlDataAccessStrategy(String path)
    {
        this.path = path;
        tags = new ArrayList<>();
    }

    @Override
    public void Connect()
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
    public void GetData()
    {
        VisitNode(document.getDocumentElement());
    }

    @Override
    public void ProcessData()
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
    public void CloseConnection()
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
