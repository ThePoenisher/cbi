/*
 compare with	http://anandam.name/pbkdf2/
 carefull, for utf8 use: str2rstr_utf8 before enterin the password

 php -r 'echo hash_pbkdf2("sha1","ä","a",100,128);'
*************
**
** Anthony Thyssen   4 November 2009      A.Thyssen@griffith.edu.au
**
** Build
**    gcc -o pbkdf2 pbkdf2.c -lcrypto
**
*/
#include <stdio.h>
#include <string.h>

#include <openssl/x509.h>
#include <openssl/evp.h>
#include <openssl/hmac.h>

void print_hex(unsigned char *buf, int len)
{
  int i;
  int n;

  for(i=0,n=0;i<len;i++){
    printf("%02x",buf[i]);
  }
  printf("\n");
}

void hex_to_binary(unsigned char *buf, unsigned char *hex)
{
  for( ; sscanf( hex, "%2X", buf++ ) == 1 ; hex+=2 );
  *buf = 0;  // null terminate -- precaution
}

int main(argc, argv)
  int argc;
  char *argv[];
{
  unsigned char pass[1024];      // passphrase read from stdin
  unsigned char salt[1024];      // salt (binary)
  int salt_len;                  // salt length in bytes
  int dklen;                 
  int ic;                        // iterative count
  unsigned char result[1024];       // result

  if ( argc != 4 ) {
    fprintf(stderr, "usage: %s salt count dklen <passwd >binary_key_iv\n", argv[0]);
    exit(10);
  }

	hex_to_binary(salt, argv[1]);
  salt_len=strlen(argv[1]); 
	if(salt_len%2){
		printf("salt len has to be even");
		return 1;
	}
	salt_len/=2;

  ic = atoi(argv[2]);
  dklen = atoi(argv[3]);

  fgets(pass, 1024, stdin);
  if ( pass[strlen(pass)-1] == '\n' )
    pass[strlen(pass)-1] = '\0';

  PKCS5_PBKDF2_HMAC_SHA1(pass, strlen(pass), salt, salt_len, ic, dklen , result);
  print_hex(result, dklen);
  return(0);
}
