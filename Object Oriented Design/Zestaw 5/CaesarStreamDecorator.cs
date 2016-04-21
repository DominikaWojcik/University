using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace Lista555
{
    class CaesarStreamDecorator : Stream
    {
        private Stream stream;
        private int shift;

        public CaesarStreamDecorator(Stream stream, int shift)
        {
            this.stream = stream;
            this.shift = shift;
        }

        public override void Close()
        {
            stream.Close();
            base.Close();
        }

        public override int Read(byte[] buffer, int offset, int count)
        {
            byte[] tmpbuf = new byte[count];
            int bytesRead = stream.Read(tmpbuf, 0, count);
            for (int j = 0; j < bytesRead; j++)
            {
                buffer[offset + (j + shift + bytesRead) % bytesRead] = tmpbuf[j];
            }

            return bytesRead;
        }

        public override void Write(byte[] buffer, int offset, int count)
        {
            byte[] tmpbuf = new byte[count];
            for (int j = 0; j < count; j++)
            {
                tmpbuf[(j + shift + count) % count] = buffer[offset + j]; 
            }
            stream.Write(tmpbuf, 0, count);
        }

        public override bool CanRead
        {
            get { throw new NotImplementedException(); }
        }

        public override bool CanSeek
        {
            get { throw new NotImplementedException(); }
        }

        public override bool CanWrite
        {
            get { throw new NotImplementedException(); }
        }

        public override void Flush()
        {
            throw new NotImplementedException();
        }

        public override long Length
        {
            get { throw new NotImplementedException(); }
        }

        public override long Position
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        public override long Seek(long offset, SeekOrigin origin)
        {
            throw new NotImplementedException();
        }

        public override void SetLength(long value)
        {
            throw new NotImplementedException();
        }
    }
}
