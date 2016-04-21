using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace Lista555
{
    public class SmtpFacade
    {
        public void Send(string From, string To, string Password, string Subject, string Body, Stream Attachment, string AttachmentMimeType)
        {
            MailMessage message = new MailMessage(From, To, Subject, Body);

            if (Attachment != null)
            {
                Attachment attachment = new Attachment(Attachment, null, AttachmentMimeType);
                message.Attachments.Add(attachment);
            }

            SmtpClient client = new SmtpClient("smtp.gmail.com", 587)
            {
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                Credentials = new NetworkCredential(From, Password)
            };

            try
            {
                client.Send(message);
            }
            catch(Exception e)
            {
                Console.WriteLine("Wyjątek przy wysyłaniu wiadomości: " + e.ToString());
                Console.WriteLine("\nByc moze nie włączyles w ustawieniach gmaila dostępu dla mało bezpiecznych aplikacji");
            }
        }
    }
}
