import { IsNotEmpty, IsString } from 'class-validator';

export class AuthenticateDistributorDto {
  @IsString()
  @IsNotEmpty()
  uesrName: string;

  @IsString()
  @IsNotEmpty()
  password: string;

  @IsString()
  @IsNotEmpty()
  DistributorCode: string;
}

